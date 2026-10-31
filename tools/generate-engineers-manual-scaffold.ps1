param()

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$manualRoot = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\engineers_manual"
$ieManualRoot = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\manual"
$ieIntegrationManualRoot = Join-Path $projectRoot "src\main\resources\assets\immersiveengineering\manual"
$coveragePath = Join-Path $projectRoot "docs\engineers-manual\FEATURE_COVERAGE.csv"
$fullContentPath = Join-Path $projectRoot "docs\engineers-manual\FULL_CONTENT.json"
$enLangPath = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\lang\en_us.lang"
$frLangPath = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\lang\fr_fr.lang"
$enLangJsonPath = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\lang\en_us.json"
$frLangJsonPath = Join-Path $projectRoot "src\main\resources\assets\immersiverailroading\lang\fr_fr.json"
$ieManualCategory = "immersive_railroading"

$categoryTitles = @{
    "commands" = @("Commands and Administration", "Commandes et administration")
    "configuration" = @("Configuration and Performance", "Configuration et performance")
    "controls" = @("Controls and Key Bindings", "Commandes et raccourcis")
    "coupling_brakes" = @("Coupling, Brakes, and Train Handling", "Attelage, freins et conduite")
    "credits_support" = @("Credits, Legal, and Support", "Credits, licence et support")
    "diesel_locomotives" = @("Diesel Locomotives", "Locomotives diesel")
    "fluid_logistics" = @("Fluid Logistics", "Logistique des fluides")
    "freight_logistics" = @("Freight and Item Logistics", "Logistique du fret et des objets")
    "gauges_and_scale" = @("Gauges and Scale", "Ecartements et echelle")
    "getting_started" = @("Getting Started", "Premiers pas")
    "manufacturing" = @("Manufacturing and Recipes", "Fabrication et recettes")
    "passenger_operations" = @("Passenger Operations", "Operations voyageurs")
    "rail_augments" = @("Rail Augments and Automation", "Modules de voie et automatisation")
    "resource_packs" = @("Resource Packs and Custom Rolling Stock", "Packs de ressources et materiel roulant personnalise")
    "rolling_stock" = @("Rolling Stock", "Materiel roulant")
    "steam_locomotives" = @("Steam Locomotives", "Locomotives a vapeur")
    "switches_tables" = @("Switches, Tables, and Special Track", "Aiguillages, tables et voies speciales")
    "tools_and_equipment" = @("Tools and Equipment", "Outils et equipement")
    "track_planning" = @("Track Planning", "Planification de voie")
    "track_construction" = @("Track Construction", "Construction de voie")
    "track_types" = @("Track Types", "Types de voie")
    "troubleshooting" = @("Troubleshooting", "Depannage")
    "welcome" = @("Welcome", "Bienvenue")
    "workshop_multiblocks" = @("Workshop and Multiblocks", "Atelier et multiblocs")
}

function ConvertTo-Title {
    param([Parameter(Mandatory = $true)][string]$Value)
    return (($Value -replace '^.*\/', '') -split '_' | ForEach-Object {
        if ($_.Length -eq 0) {
            $_
        } else {
            $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1)
        }
    }) -join ' '
}

function ConvertTo-JsonFile {
    param(
        [Parameter(Mandatory = $true)]$Value,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $parent = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $json = $Value | ConvertTo-Json -Depth 12
    Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

function Read-LangMap {
    param([Parameter(Mandatory = $true)][string]$Path)
    $map = [ordered]@{}
    if (Test-Path -LiteralPath $Path) {
        foreach ($line in Get-Content -LiteralPath $Path -Encoding UTF8) {
            if ($line.Trim().Length -eq 0 -or $line.TrimStart().StartsWith("#") -or -not $line.Contains("=")) {
                continue
            }
            $idx = $line.IndexOf("=")
            $key = $line.Substring(0, $idx)
            $value = $line.Substring($idx + 1)
            if (-not $map.Contains($key)) {
                $map[$key] = $value
            }
        }
    }
    return $map
}

function Add-LangEntries {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][hashtable]$Entries
    )

    $pending = @{}
    foreach ($key in ($Entries.Keys | Sort-Object)) {
        $pending[$key] = "$key=$($Entries[$key])"
    }

    $lines = @()
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)
    }

    $updated = New-Object System.Collections.Generic.List[string]
    $seen = @{}
    foreach ($line in $lines) {
        $idx = $line.IndexOf("=")
        if ($idx -gt 0) {
            $key = $line.Substring(0, $idx)
            if ($pending.ContainsKey($key)) {
                if (-not $seen.ContainsKey($key)) {
                    $updated.Add($pending[$key])
                    $seen[$key] = $true
                }
                continue
            }
        }
        $updated.Add($line)
    }

    $missing = @($Entries.Keys | Sort-Object | Where-Object { -not $seen.ContainsKey($_) })
    if ($missing.Count -gt 0) {
        if ($updated.Count -gt 0 -and $updated[$updated.Count - 1].Trim().Length -gt 0) {
            $updated.Add("")
        }
        $updated.Add("# Engineer Manual full implementation")
        foreach ($key in $missing) {
            $updated.Add($pending[$key])
        }
    }

    Set-Content -LiteralPath $Path -Value $updated -Encoding UTF8
}

function Add-JsonLangEntries {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][hashtable]$Entries
    )

    $existing = [ordered]@{}
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $json = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($property in $json.PSObject.Properties) {
            $existing[$property.Name] = $property.Value
        }
    }
    foreach ($key in ($Entries.Keys | Sort-Object)) {
        $existing[$key] = $Entries[$key]
    }
    ConvertTo-JsonFile -Path $Path -Value $existing
}

function Get-LangValue {
    param(
        [Parameter(Mandatory = $true)][System.Collections.IDictionary]$Map,
        [Parameter(Mandatory = $true)][string]$Key,
        [Parameter(Mandatory = $true)][string]$Fallback
    )

    if ($Map.Contains($Key)) {
        return $Map[$Key]
    }
    return $Fallback
}

function ConvertTo-IEManualEntryName {
    param([Parameter(Mandatory = $true)][string]$EntryId)

    $path = $EntryId
    if ($path.Contains(":")) {
        $path = $path.Substring($path.IndexOf(":") + 1)
    }
    $path = $path -replace "^engineers_manual/", ""
    $path = $path -replace "/", "_"
    $path = $path -replace "[^a-zA-Z0-9_.-]", "_"
    return $path.ToLowerInvariant()
}

function ConvertTo-IEManualText {
    param([AllowNull()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }
    $text = $Value -replace "\r?\n", " "
    $text = $text -replace "\s+", " "
    return $text.Trim()
}

function Write-IEManualTextFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Title,
        [Parameter(Mandatory = $true)][string]$Subtitle,
        [Parameter(Mandatory = $true)][string[]]$Paragraphs
    )

    $parent = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $body = ($Paragraphs | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join "<br><br>"
    if ([string]::IsNullOrWhiteSpace($body)) {
        $body = $Subtitle
    }
    Set-Content -LiteralPath $Path -Value @($Title, $Subtitle, $body) -Encoding UTF8
}

function Write-ImmersiveEngineeringManual {
    $enLang = Read-LangMap -Path $enLangPath
    $frLang = Read-LangMap -Path $frLangPath
    $entryFiles = @(Get-ChildItem -LiteralPath (Join-Path $manualRoot "entries") -Recurse -Filter "*.json" -File | Sort-Object FullName)
    $categoryFiles = @(Get-ChildItem -LiteralPath (Join-Path $manualRoot "categories") -Filter "*.json" -File | Sort-Object FullName)
    $categoryTitlesEn = @{}
    $categoryTitlesFr = @{}

    foreach ($categoryFile in $categoryFiles) {
        $category = Get-Content -LiteralPath $categoryFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        $categoryTitlesEn[$category.id] = Get-LangValue -Map $enLang -Key $category.title -Fallback (ConvertTo-Title $categoryFile.BaseName)
        $categoryTitlesFr[$category.id] = Get-LangValue -Map $frLang -Key $category.title -Fallback $categoryTitlesEn[$category.id]
    }

    $ieEntries = @()
    $writtenTextFiles = 0
    foreach ($entryFile in $entryFiles) {
        $entry = Get-Content -LiteralPath $entryFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        $entryName = ConvertTo-IEManualEntryName -EntryId $entry.id
        $ieEntries += $entryName

        ConvertTo-JsonFile -Path (Join-Path $ieManualRoot "$entryName.json") -Value ([ordered]@{})

        $titleEn = ConvertTo-IEManualText (Get-LangValue -Map $enLang -Key $entry.title -Fallback (ConvertTo-Title $entryName))
        $titleFr = ConvertTo-IEManualText (Get-LangValue -Map $frLang -Key $entry.title -Fallback $titleEn)
        $subtitleEn = ConvertTo-IEManualText (Get-LangValue -Map $categoryTitlesEn -Key $entry.category -Fallback "Immersive Railroading Reforged")
        $subtitleFr = ConvertTo-IEManualText (Get-LangValue -Map $categoryTitlesFr -Key $entry.category -Fallback $subtitleEn)
        $paragraphsEn = @()
        $paragraphsFr = @()

        foreach ($page in $entry.pages) {
            if (-not $page.text) {
                continue
            }
            $enText = ConvertTo-IEManualText (Get-LangValue -Map $enLang -Key $page.text -Fallback $page.text)
            $frText = ConvertTo-IEManualText (Get-LangValue -Map $frLang -Key $page.text -Fallback $enText)
            if ($page.type -eq "heading" -and $enText -eq $titleEn) {
                continue
            }
            if ($page.type -eq "callout") {
                $enText = "Note: $enText"
                $frText = "Note : $frText"
            }
            $paragraphsEn += $enText
            $paragraphsFr += $frText
        }

        Write-IEManualTextFile -Path (Join-Path $ieManualRoot "en_us\$entryName.txt") -Title $titleEn -Subtitle $subtitleEn -Paragraphs $paragraphsEn
        Write-IEManualTextFile -Path (Join-Path $ieManualRoot "fr_fr\$entryName.txt") -Title $titleFr -Subtitle $subtitleFr -Paragraphs $paragraphsFr
        $writtenTextFiles += 2
    }

    $ieEntries = @($ieEntries | Sort-Object {
        if ($_ -eq "welcome") {
            "000_$_"
        } elseif ($_ -eq "item_manual") {
            "001_$_"
        } else {
            "100_$_"
        }
    })

    $ieEntryRefs = @($ieEntries | ForEach-Object { "immersiverailroading:$_" })
    $autoload = [ordered]@{
        autoload_priority = 3
    }
    $autoload["immersiverailroading:$ieManualCategory"] = [ordered]@{
        category_weight = 102
        entry_list = @($ieEntryRefs)
    }
    ConvertTo-JsonFile -Path (Join-Path $ieIntegrationManualRoot "autoload.json") -Value $autoload
    ConvertTo-JsonFile -Path (Join-Path $ieManualRoot "autoload.json") -Value $autoload

    $enCategoryEntry = @{
        "manual.immersiverailroading.$ieManualCategory" = "Immersive Railroading Reforged"
    }
    $frCategoryEntry = @{
        "manual.immersiverailroading.$ieManualCategory" = "Immersive Railroading Reforged"
    }
    Add-LangEntries -Path $enLangPath -Entries $enCategoryEntry
    Add-LangEntries -Path $frLangPath -Entries $frCategoryEntry
    Add-JsonLangEntries -Path $enLangJsonPath -Entries $enCategoryEntry
    Add-JsonLangEntries -Path $frLangJsonPath -Entries $frCategoryEntry

    return [pscustomobject]@{
        Category = $ieManualCategory
        EntryCount = $ieEntries.Count
        TextFileCount = $writtenTextFiles
    }
}

function Get-ManualResourcePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $resourceFullPath = [System.IO.Path]::GetFullPath((Join-Path $projectRoot "src\main\resources"))
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    if (-not $fullPath.StartsWith($resourceFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Manual resource is outside resource root: $Path"
    }
    $relativePath = $fullPath.Substring($resourceFullPath.Length).TrimStart([char[]]"\/")
    return $relativePath -replace "\\", "/"
}

function Write-ManualIndex {
    $categoriesDir = Join-Path $manualRoot "categories"
    $entriesDir = Join-Path $manualRoot "entries"
    $categoryFiles = @()
    $entryFiles = @()

    if (Test-Path -LiteralPath $categoriesDir -PathType Container) {
        $categoryFiles = @(Get-ChildItem -LiteralPath $categoriesDir -Filter "*.json" -File | Sort-Object FullName)
    }
    if (Test-Path -LiteralPath $entriesDir -PathType Container) {
        $entryFiles = @(Get-ChildItem -LiteralPath $entriesDir -Recurse -Filter "*.json" -File | Sort-Object FullName)
    }

    ConvertTo-JsonFile -Path (Join-Path $manualRoot "index.json") -Value ([ordered]@{
        schema_version = 1
        book = Get-ManualResourcePath (Join-Path $manualRoot "book.json")
        categories = @($categoryFiles | ForEach-Object { Get-ManualResourcePath $_.FullName })
        entries = @($entryFiles | ForEach-Object { Get-ManualResourcePath $_.FullName })
    })

    return [pscustomobject]@{
        CategoryCount = $categoryFiles.Count
        EntryCount = $entryFiles.Count
    }
}

if (-not (Test-Path -LiteralPath $coveragePath -PathType Leaf)) {
    throw "Missing coverage CSV: $coveragePath"
}

$lines = Get-Content -LiteralPath $coveragePath -Encoding UTF8 | Where-Object { $_.Trim().Length -gt 0 }
if ($lines.Count -lt 2) {
    throw "Coverage CSV has no rows: $coveragePath"
}

$header = $lines[0]
$expectedHeader = "feature_id,owning_mod,feature_type,registry_or_class,player_visible,developer_visible,manual_category,manual_entry_id,en_us_status,fr_fr_status,screenshot_required,test_required,implementation_status,notes"
if ($header -ne $expectedHeader) {
    throw "Unexpected coverage CSV header"
}

$rows = foreach ($line in $lines[1..($lines.Count - 1)]) {
    $parts = $line -split ",", 14
    if ($parts.Count -ne 14) {
        throw "Coverage row must have 14 columns: $line"
    }
    [pscustomobject]@{
        feature_id = $parts[0]
        owning_mod = $parts[1]
        feature_type = $parts[2]
        registry_or_class = $parts[3]
        player_visible = $parts[4]
        developer_visible = $parts[5]
        manual_category = $parts[6]
        manual_entry_id = $parts[7]
        en_us_status = $parts[8]
        fr_fr_status = $parts[9]
        screenshot_required = $parts[10]
        test_required = $parts[11]
        implementation_status = $parts[12]
        notes = $parts[13]
    }
}

$entryContent = @{}
$fullContent = $null
if (Test-Path -LiteralPath $fullContentPath -PathType Leaf) {
    $fullContent = Get-Content -LiteralPath $fullContentPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($fullContent.entries) {
        foreach ($property in $fullContent.entries.PSObject.Properties) {
            $entryContent[$property.Name] = $property.Value
        }
    }
    if ($fullContent.additional_coverage_rows) {
        $existingFeatureIds = @($rows | ForEach-Object { $_.feature_id })
        foreach ($extraRow in $fullContent.additional_coverage_rows) {
            if ($existingFeatureIds -contains $extraRow.feature_id) {
                continue
            }
            $rows += [pscustomobject]@{
                feature_id = $extraRow.feature_id
                owning_mod = $extraRow.owning_mod
                feature_type = $extraRow.feature_type
                registry_or_class = $extraRow.registry_or_class
                player_visible = $extraRow.player_visible
                developer_visible = $extraRow.developer_visible
                manual_category = $extraRow.manual_category
                manual_entry_id = $extraRow.manual_entry_id
                en_us_status = $extraRow.en_us_status
                fr_fr_status = $extraRow.fr_fr_status
                screenshot_required = $extraRow.screenshot_required
                test_required = $extraRow.test_required
                implementation_status = $extraRow.implementation_status
                notes = $extraRow.notes
            }
            $existingFeatureIds += $extraRow.feature_id
        }
    }
}

function Get-ManualContentValue {
    param(
        [AllowNull()]$Content,
        [Parameter(Mandatory = $true)][string]$Property,
        [AllowNull()][string]$Fallback
    )

    if ($null -ne $Content -and $Content.PSObject.Properties[$Property] -and -not [string]::IsNullOrWhiteSpace($Content.$Property)) {
        return [string]$Content.$Property
    }
    return $Fallback
}

$enEntries = @{}
$frEntries = @{}
$createdCategories = 0
$createdEntries = 0

foreach ($category in ($rows.manual_category | Sort-Object -Unique)) {
    $categoryPath = Join-Path $manualRoot "categories\$category.json"
    $categoryId = "immersiverailroading:engineers_manual/$category"
    $titlePair = $categoryTitles[$category]
    if (-not $titlePair) {
        $titlePair = @(ConvertTo-Title $category, "Reference $category")
    }
    $titleKey = "manual.immersiverailroading.category.$category.title"
    $descriptionKey = "manual.immersiverailroading.category.$category.description"

    if (-not (Test-Path -LiteralPath $categoryPath -PathType Leaf)) {
        ConvertTo-JsonFile -Path $categoryPath -Value ([ordered]@{
            schema_version = 1
            id = $categoryId
            title = $titleKey
            description = $descriptionKey
            icon = "immersiverailroading:item_manual"
            sort_order = 100 + $createdCategories
        })
        $createdCategories++
    }

    $enEntries[$titleKey] = $titlePair[0]
    $frEntries[$titleKey] = $titlePair[1]
    $enEntries[$descriptionKey] = "Source-backed reference entries for $($titlePair[0])."
    $frEntries[$descriptionKey] = "Entrees de reference basees sur le code pour $($titlePair[1])."
}

$entryGroups = $rows | Group-Object manual_entry_id
foreach ($group in ($entryGroups | Sort-Object Name)) {
    $entryId = $group.Name
    $entrySlug = ($entryId -replace '^.*\/', '')
    $category = ($group.Group | Select-Object -First 1).manual_category
    $entryPath = Join-Path $manualRoot "entries\$category\$entrySlug.json"

    $entryExists = Test-Path -LiteralPath $entryPath -PathType Leaf

    $features = @($group.Group | Sort-Object feature_id)
    $featureIds = @($features | ForEach-Object { $_.feature_id })
    $sourceRefs = @($features | ForEach-Object { $_.registry_or_class } | Sort-Object -Unique)
    $featureTypes = @($features | ForEach-Object { $_.feature_type } | Sort-Object -Unique)
    $title = ConvertTo-Title $entrySlug
    $content = if ($entryContent.ContainsKey($entrySlug)) { $entryContent[$entrySlug] } else { $null }
    $titleKey = "manual.immersiverailroading.entry.$entrySlug.title"
    $headingKey = "manual.immersiverailroading.entry.$entrySlug.heading"
    $keywordKey = "manual.immersiverailroading.entry.$entrySlug.keyword"
    $bodyKey = "manual.immersiverailroading.entry.$entrySlug.body"
    $sourceKey = "manual.immersiverailroading.entry.$entrySlug.source"

    ConvertTo-JsonFile -Path $entryPath -Value ([ordered]@{
        schema_version = 1
        id = $entryId
        category = "immersiverailroading:engineers_manual/$category"
        title = $titleKey
        icon = "immersiverailroading:item_manual"
        sort_order = 100
        keywords = @($keywordKey)
        aliases = @($entrySlug) + $featureIds
        conditions = @()
        pages = @(
            [ordered]@{
                type = "heading"
                text = $headingKey
            },
            [ordered]@{
                type = "text"
                text = $bodyKey
            },
            [ordered]@{
                type = "callout"
                style = "info"
                text = $sourceKey
            }
        )
        related_entries = @("immersiverailroading:engineers_manual/welcome")
        source_feature_ids = $featureIds
        technical = $false
        hidden = $false
    })
    if (-not $entryExists) {
        $createdEntries++
    }

    $enTitle = Get-ManualContentValue -Content $content -Property "title_en" -Fallback $title
    $frTitle = Get-ManualContentValue -Content $content -Property "title_fr" -Fallback $enTitle
    $enEntries[$titleKey] = $enTitle
    $enEntries[$headingKey] = Get-ManualContentValue -Content $content -Property "heading_en" -Fallback $enTitle
    $enEntries[$keywordKey] = Get-ManualContentValue -Content $content -Property "keyword_en" -Fallback ($featureTypes -join " ")
    $enEntries[$bodyKey] = Get-ManualContentValue -Content $content -Property "body_en" -Fallback "Covers $($featureIds -join ', ') as implemented by the current Immersive Railroading source. Use this entry as the source-backed reference point for player-facing behavior."
    $enEntries[$sourceKey] = Get-ManualContentValue -Content $content -Property "source_en" -Fallback "Source basis: $($sourceRefs -join '; ')."

    $frEntries[$titleKey] = $frTitle
    $frEntries[$headingKey] = Get-ManualContentValue -Content $content -Property "heading_fr" -Fallback $frTitle
    $frEntries[$keywordKey] = Get-ManualContentValue -Content $content -Property "keyword_fr" -Fallback ($featureTypes -join " ")
    $frEntries[$bodyKey] = Get-ManualContentValue -Content $content -Property "body_fr" -Fallback (Get-ManualContentValue -Content $content -Property "body_en" -Fallback "Couvre $($featureIds -join ', ') tel qu'implemente dans le code actuel d'Immersive Railroading. Utilisez cette entree comme reference basee sur le code pour le comportement visible en jeu.")
    $frEntries[$sourceKey] = Get-ManualContentValue -Content $content -Property "source_fr" -Fallback "Base source : $($sourceRefs -join '; ')."
}

Add-LangEntries -Path $enLangPath -Entries $enEntries
Add-LangEntries -Path $frLangPath -Entries $frEntries

$updatedLines = @($header)
foreach ($row in $rows) {
    $rowSlug = ($row.manual_entry_id -replace '^.*\/', '')
    $isFullContent = $entryContent.ContainsKey($rowSlug)
    $enStatus = if ($row.en_us_status -eq "complete" -or $isFullContent) { "complete" } else { "scaffolded" }
    $frStatus = if ($row.fr_fr_status -eq "complete" -or $isFullContent) { "complete" } else { "scaffolded" }
    $implementationStatus = if ($isFullContent) { "documented" } elseif ($row.implementation_status -in @("documented", "generated")) { $row.implementation_status } else { "scaffolded" }
    $updatedLines += @(
        $row.feature_id,
        $row.owning_mod,
        $row.feature_type,
        $row.registry_or_class,
        $row.player_visible,
        $row.developer_visible,
        $row.manual_category,
        $row.manual_entry_id,
        $enStatus,
        $frStatus,
        $row.screenshot_required,
        $row.test_required,
        $implementationStatus,
        $row.notes
    ) -join ","
}
[System.IO.File]::WriteAllLines($coveragePath, $updatedLines, [System.Text.UTF8Encoding]::new($false))
$manualIndex = Write-ManualIndex
$ieManual = Write-ImmersiveEngineeringManual

[pscustomobject]@{
    CreatedCategories = $createdCategories
    CreatedEntries = $createdEntries
    UpdatedCoverageRows = $rows.Count
    EnKeysConsidered = $enEntries.Count
    FrKeysConsidered = $frEntries.Count
    IndexedCategories = $manualIndex.CategoryCount
    IndexedEntries = $manualIndex.EntryCount
    ImmersiveEngineeringManualCategory = $ieManual.Category
    ImmersiveEngineeringManualEntries = $ieManual.EntryCount
    ImmersiveEngineeringManualTextFiles = $ieManual.TextFileCount
} | Format-List
