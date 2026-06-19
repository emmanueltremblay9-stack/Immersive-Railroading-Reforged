param(
    [string]$ModsDir = $env:CODEX_MINECRAFT_MODS_DIR,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSCommandPath
if (-not $ModsDir) {
    $ModsDir = "C:\Users\Emmanuel Tremblay\AppData\Roaming\PrismLauncher\instances\1.21.1 TesT LaB\minecraft\mods"
}

if (-not (Test-Path -LiteralPath $ModsDir -PathType Container)) {
    throw "Mods directory does not exist: $ModsDir"
}

$modsDirPath = (Resolve-Path -LiteralPath $ModsDir).Path
$buildGradle = Join-Path $projectRoot "build.gradle"
$buildText = Get-Content -Raw -LiteralPath $buildGradle
if ($buildText -notmatch "version\s*=\s*'([^']+)'") {
    throw "Could not detect version literal from build.gradle"
}

$versionLiteral = $Matches[1]
$gitShort = (& git -C $projectRoot rev-parse --verify --short=7 HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or -not $gitShort) {
    throw "Could not detect git short SHA"
}

$expectedVersion = "$versionLiteral-$gitShort"
$modId = "immersiverailroading"
$modName = "Immersive Railroading Reforged"

if (-not $SkipBuild) {
    Push-Location $projectRoot
    try {
        & .\gradlew.bat clean build
        if ($LASTEXITCODE -ne 0) {
            throw "Gradle clean build failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-JarTextEntry {
    param(
        [Parameter(Mandatory = $true)][string]$JarPath,
        [Parameter(Mandatory = $true)][string[]]$EntryNames
    )

    $zip = [System.IO.Compression.ZipFile]::OpenRead($JarPath)
    try {
        foreach ($entryName in $EntryNames) {
            $entry = $zip.GetEntry($entryName)
            if ($entry) {
                $reader = New-Object System.IO.StreamReader($entry.Open())
                try {
                    return $reader.ReadToEnd()
                } finally {
                    $reader.Dispose()
                }
            }
        }
        return $null
    } finally {
        $zip.Dispose()
    }
}

function Test-JarContainsEntry {
    param(
        [Parameter(Mandatory = $true)][string]$JarPath,
        [Parameter(Mandatory = $true)][string]$EntryName
    )

    $zip = [System.IO.Compression.ZipFile]::OpenRead($JarPath)
    try {
        return $null -ne $zip.GetEntry($EntryName)
    } finally {
        $zip.Dispose()
    }
}

function Get-JarModId {
    param([Parameter(Mandatory = $true)][string]$JarPath)

    try {
        $metadata = Get-JarTextEntry -JarPath $JarPath -EntryNames @(
            "META-INF/neoforge.mods.toml",
            "META-INF/mods.toml"
        )
        if ($metadata -and $metadata -match 'modId\s*=\s*"([^"]+)"') {
            return $Matches[1]
        }
    } catch {
        return $null
    }
    return $null
}

$libsDir = Join-Path $projectRoot "build\libs"
if (-not (Test-Path -LiteralPath $libsDir -PathType Container)) {
    throw "Build output directory does not exist: $libsDir"
}

$excludedClassifierPattern = "(?i)(sources|javadoc|dev|plain|test|tests|api|shadow|shaded|downgraded)"
$runtimeCandidates = @(
    Get-ChildItem -LiteralPath $libsDir -Filter "*.jar" |
        Where-Object { $_.Name -notmatch $excludedClassifierPattern } |
        Where-Object { (Get-JarModId -JarPath $_.FullName) -eq $modId }
)

if ($runtimeCandidates.Count -eq 0) {
    throw "No runtime JAR containing mod id '$modId' was found in $libsDir"
}

$selected = @($runtimeCandidates | Where-Object { $_.BaseName -like "*$expectedVersion*" })
if ($selected.Count -ne 1) {
    if ($runtimeCandidates.Count -eq 1) {
        $selected = @($runtimeCandidates[0])
    } else {
        throw "Expected one runtime JAR for version $expectedVersion, found $($runtimeCandidates.Count)"
    }
}

$sourceJar = $selected[0]
$installedName = $sourceJar.Name
$targetJar = Join-Path $modsDirPath $installedName

$oldJars = @(
    Get-ChildItem -LiteralPath $modsDirPath -Filter "*.jar" |
        Where-Object { (Get-JarModId -JarPath $_.FullName) -eq $modId }
)

foreach ($oldJar in $oldJars) {
    Remove-Item -LiteralPath $oldJar.FullName -Force
}

Copy-Item -LiteralPath $sourceJar.FullName -Destination $targetJar -Force

$sourceItem = Get-Item -LiteralPath $sourceJar.FullName
$targetItem = Get-Item -LiteralPath $targetJar
$sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $sourceJar.FullName).Hash
$targetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $targetJar).Hash

$remaining = @(
    Get-ChildItem -LiteralPath $modsDirPath -Filter "*.jar" |
        Where-Object { (Get-JarModId -JarPath $_.FullName) -eq $modId }
)

$metadata = Get-JarTextEntry -JarPath $targetJar -EntryNames @("META-INF/neoforge.mods.toml", "META-INF/mods.toml")
$report = [ordered]@{
    ModId = $modId
    ModName = $modName
    VersionLiteral = $versionLiteral
    InstalledVersion = $expectedVersion
    SourceJar = $sourceItem.FullName
    InstalledJar = $targetItem.FullName
    SourceSize = $sourceItem.Length
    InstalledSize = $targetItem.Length
    SourceSha256 = $sourceHash
    InstalledSha256 = $targetHash
    HashesMatch = ($sourceHash -eq $targetHash)
    DeletedOldJars = @($oldJars | ForEach-Object { $_.FullName })
    RemainingJarsForMod = @($remaining | ForEach-Object { $_.FullName })
    RemainingJarCountForMod = $remaining.Count
    OnlyInstalledJarRemains = ($remaining.Count -eq 1 -and $remaining[0].FullName -eq $targetItem.FullName)
    ContainsNeoForgeMetadata = ($null -ne $metadata)
    ContainsLogo = (Test-JarContainsEntry -JarPath $targetJar -EntryName "immersive_railroading_neoforge_icon.png")
    ContainsModEntrypoint = (Test-JarContainsEntry -JarPath $targetJar -EntryName "cam72cam/immersiverailroading/Mod.class")
}

$reportPath = Join-Path $projectRoot "build\install-report.json"
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding UTF8

if (-not $report.HashesMatch) {
    throw "Installed JAR hash does not match source JAR"
}

if (-not $report.OnlyInstalledJarRemains) {
    throw "Expected exactly one installed JAR for $modId"
}

$report
