param(
    [string]$ModsDir = $env:CODEX_MINECRAFT_MODS_DIR,
    [string]$ProjectLibDir,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSCommandPath
if (-not $ModsDir) {
    $ModsDir = "C:\Users\Emmanuel Tremblay\AppData\Roaming\PrismLauncher\instances\1.21.1 TesT LaB\minecraft\mods"
}

if (-not $ProjectLibDir) {
    $ProjectLibDir = Join-Path $projectRoot "lib"
}

if (-not (Test-Path -LiteralPath $ModsDir -PathType Container)) {
    throw "Mods directory does not exist: $ModsDir"
}

$modsDirPath = (Resolve-Path -LiteralPath $ModsDir).Path
New-Item -ItemType Directory -Force -Path $ProjectLibDir | Out-Null
$projectLibPath = (Resolve-Path -LiteralPath $ProjectLibDir).Path
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

function Find-JarsByModId {
    param(
        [Parameter(Mandatory = $true)][string]$Directory,
        [Parameter(Mandatory = $true)][string]$ModId
    )

    if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
        return @()
    }

    return @(
        Get-ChildItem -LiteralPath $Directory -Filter "*.jar" |
            Where-Object { (Get-JarModId -JarPath $_.FullName) -eq $ModId }
    )
}

function Copy-VerifiedJar {
    param(
        [Parameter(Mandatory = $true)][string]$SourceJar,
        [Parameter(Mandatory = $true)][string]$DestinationDir
    )

    New-Item -ItemType Directory -Force -Path $DestinationDir | Out-Null
    $destination = Join-Path $DestinationDir (Split-Path -Leaf $SourceJar)
    Copy-Item -LiteralPath $SourceJar -Destination $destination -Force

    $sourceItem = Get-Item -LiteralPath $SourceJar
    $targetItem = Get-Item -LiteralPath $destination
    $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $SourceJar).Hash
    $targetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $destination).Hash

    return [ordered]@{
        SourceJar = $sourceItem.FullName
        TargetJar = $targetItem.FullName
        SourceSize = $sourceItem.Length
        TargetSize = $targetItem.Length
        SourceSha256 = $sourceHash
        TargetSha256 = $targetHash
        HashesMatch = ($sourceHash -eq $targetHash)
    }
}

function Resolve-GradleCacheJar {
    param(
        [Parameter(Mandatory = $true)][string]$ModulePath,
        [Parameter(Mandatory = $true)][string]$FileName
    )

    $cacheRoot = Join-Path $env:USERPROFILE ".gradle\caches\modules-2\files-2.1"
    $moduleRoot = Join-Path $cacheRoot $ModulePath
    $matches = @(
        Get-ChildItem -LiteralPath $moduleRoot -Recurse -Filter $FileName -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch "(?i)-(sources|javadoc|dev|plain|test|tests|api|shadow|shaded|downgraded)(-|\.|$)" }
    )

    if ($matches.Count -ne 1) {
        throw "Expected exactly one cached dependency jar '$FileName' under '$moduleRoot', found $($matches.Count)"
    }

    return $matches[0]
}

$libsDir = Join-Path $projectRoot "build\libs"
if (-not (Test-Path -LiteralPath $libsDir -PathType Container)) {
    throw "Build output directory does not exist: $libsDir"
}

$excludedClassifierPattern = "(?i)-(sources|javadoc|dev|plain|test|tests|api|shadow|shaded|downgraded)(-|\.|$)"
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
$actualInstalledVersion = $expectedVersion
if ($sourceJar.BaseName -match "^ImmersiveRailroading-(.+)$") {
    $actualInstalledVersion = $Matches[1]
}
$installedName = $sourceJar.Name
$targetJar = Join-Path $modsDirPath $installedName
$projectLibJar = Join-Path $projectLibPath $installedName

$runtimeDependencySpecs = @(
    [ordered]@{
        ModId = "universalmodcore"
        ModulePath = "cam72cam.universalmodcore\UniversalModCore\1.21.1-neoforge-1.3.0-73ac499"
        FileName = "UniversalModCore-1.21.1-neoforge-1.3.0-73ac499.jar"
    },
    [ordered]@{
        ModId = "trackapi"
        ModulePath = "trackapi\TrackAPI\1.21.1-neoforge-1.2-a965c1"
        FileName = "TrackAPI-1.21.1-neoforge-1.2-a965c1.jar"
    }
)

$runtimeDependencyJars = @(
    foreach ($spec in $runtimeDependencySpecs) {
        $jar = Resolve-GradleCacheJar -ModulePath $spec.ModulePath -FileName $spec.FileName
        [ordered]@{
            ModId = $spec.ModId
            SourceJar = $jar.FullName
        }
    }
)

$oldJars = @(
    Find-JarsByModId -Directory $modsDirPath -ModId $modId
)
$oldProjectLibJars = @(
    Find-JarsByModId -Directory $projectLibPath -ModId $modId
)

foreach ($oldJar in $oldJars) {
    Remove-Item -LiteralPath $oldJar.FullName -Force
}

foreach ($oldJar in $oldProjectLibJars) {
    Remove-Item -LiteralPath $oldJar.FullName -Force
}

$installedCopy = Copy-VerifiedJar -SourceJar $sourceJar.FullName -DestinationDir $modsDirPath
$projectLibCopy = Copy-VerifiedJar -SourceJar $sourceJar.FullName -DestinationDir $projectLibPath

$remaining = @(
    Find-JarsByModId -Directory $modsDirPath -ModId $modId
)
$projectLibRemaining = @(
    Find-JarsByModId -Directory $projectLibPath -ModId $modId
)

$metadata = Get-JarTextEntry -JarPath $targetJar -EntryNames @("META-INF/neoforge.mods.toml", "META-INF/mods.toml")

$dependencyReports = @()
foreach ($dependency in $runtimeDependencyJars) {
    $depModId = $dependency.ModId
    $oldDependencyMods = @(Find-JarsByModId -Directory $modsDirPath -ModId $depModId)
    $oldDependencyLibs = @(Find-JarsByModId -Directory $projectLibPath -ModId $depModId)

    foreach ($oldJar in $oldDependencyMods) {
        Remove-Item -LiteralPath $oldJar.FullName -Force
    }
    foreach ($oldJar in $oldDependencyLibs) {
        Remove-Item -LiteralPath $oldJar.FullName -Force
    }

    $depInstalledCopy = Copy-VerifiedJar -SourceJar $dependency.SourceJar -DestinationDir $modsDirPath
    $depProjectLibCopy = Copy-VerifiedJar -SourceJar $dependency.SourceJar -DestinationDir $projectLibPath
    $depModsRemaining = @(Find-JarsByModId -Directory $modsDirPath -ModId $depModId)
    $depLibRemaining = @(Find-JarsByModId -Directory $projectLibPath -ModId $depModId)

    $dependencyReports += [ordered]@{
        ModId = $depModId
        SourceJar = $dependency.SourceJar
        InstalledJar = $depInstalledCopy.TargetJar
        ProjectLibJar = $depProjectLibCopy.TargetJar
        InstalledSha256 = $depInstalledCopy.TargetSha256
        ProjectLibSha256 = $depProjectLibCopy.TargetSha256
        InstalledHashMatch = $depInstalledCopy.HashesMatch
        ProjectLibHashMatch = $depProjectLibCopy.HashesMatch
        DeletedOldInstalledJars = @($oldDependencyMods | ForEach-Object { $_.FullName })
        DeletedOldProjectLibJars = @($oldDependencyLibs | ForEach-Object { $_.FullName })
        RemainingInstalledJarCount = $depModsRemaining.Count
        RemainingProjectLibJarCount = $depLibRemaining.Count
    }
}

$report = [ordered]@{
    ModId = $modId
    ModName = $modName
    VersionLiteral = $versionLiteral
    DesiredVersionForCurrentCommit = $expectedVersion
    InstalledVersion = $actualInstalledVersion
    SourceJar = $installedCopy.SourceJar
    InstalledJar = $installedCopy.TargetJar
    ProjectLibJar = $projectLibCopy.TargetJar
    SourceSize = $installedCopy.SourceSize
    InstalledSize = $installedCopy.TargetSize
    ProjectLibSize = $projectLibCopy.TargetSize
    SourceSha256 = $installedCopy.SourceSha256
    InstalledSha256 = $installedCopy.TargetSha256
    ProjectLibSha256 = $projectLibCopy.TargetSha256
    HashesMatch = $installedCopy.HashesMatch
    ProjectLibHashesMatch = $projectLibCopy.HashesMatch
    DeletedOldJars = @($oldJars | ForEach-Object { $_.FullName })
    DeletedOldProjectLibJars = @($oldProjectLibJars | ForEach-Object { $_.FullName })
    RemainingJarsForMod = @($remaining | ForEach-Object { $_.FullName })
    RemainingProjectLibJarsForMod = @($projectLibRemaining | ForEach-Object { $_.FullName })
    RemainingJarCountForMod = $remaining.Count
    RemainingProjectLibJarCountForMod = $projectLibRemaining.Count
    OnlyInstalledJarRemains = ($remaining.Count -eq 1 -and $remaining[0].FullName -eq $targetJar)
    OnlyProjectLibJarRemains = ($projectLibRemaining.Count -eq 1 -and $projectLibRemaining[0].FullName -eq $projectLibJar)
    ContainsNeoForgeMetadata = ($null -ne $metadata)
    ContainsLogo = (Test-JarContainsEntry -JarPath $targetJar -EntryName "immersive_railroading_neoforge_icon.png")
    ContainsModEntrypoint = (Test-JarContainsEntry -JarPath $targetJar -EntryName "cam72cam/immersiverailroading/Mod.class")
    ProjectLibDir = $projectLibPath
    RuntimeDependencies = $dependencyReports
}

$reportPath = Join-Path $projectRoot "build\install-report.json"
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding UTF8

if (-not $report.HashesMatch) {
    throw "Installed JAR hash does not match source JAR"
}

if (-not $report.ProjectLibHashesMatch) {
    throw "Project lib JAR hash does not match source JAR"
}

if (-not $report.OnlyInstalledJarRemains) {
    throw "Expected exactly one installed JAR for $modId"
}

if (-not $report.OnlyProjectLibJarRemains) {
    throw "Expected exactly one project lib JAR for $modId"
}

foreach ($dependencyReport in $dependencyReports) {
    if (-not $dependencyReport.InstalledHashMatch) {
        throw "Installed dependency hash does not match for $($dependencyReport.ModId)"
    }
    if (-not $dependencyReport.ProjectLibHashMatch) {
        throw "Project lib dependency hash does not match for $($dependencyReport.ModId)"
    }
    if ($dependencyReport.RemainingInstalledJarCount -ne 1) {
        throw "Expected exactly one installed dependency JAR for $($dependencyReport.ModId)"
    }
    if ($dependencyReport.RemainingProjectLibJarCount -ne 1) {
        throw "Expected exactly one project lib dependency JAR for $($dependencyReport.ModId)"
    }
}

$report
