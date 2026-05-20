#Requires -Version 7.0
#Requires -Modules platyPS

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('All', 'Docs', 'Test', 'IntegrationTest', 'Package')]
    [string[]]$Task = 'All'
)

$ErrorActionPreference = 'Stop'

$moduleName   = 'ServiceDesk.Cloud.Requests'
$moduleRoot   = "$PSScriptRoot/$moduleName"
$manifestPath = "$moduleRoot/$moduleName.psd1"
$docsPath     = "$PSScriptRoot/docs/en-US"
$helpOutPath  = "$moduleRoot/en-US"
$testsPath    = "$PSScriptRoot/tests"

function Invoke-BuildDocs {
    Write-Host 'Building documentation...' -ForegroundColor Cyan

    Import-Module platyPS  -Force
    Import-Module $manifestPath -Force

    New-Item -ItemType Directory -Path $docsPath  -Force | Out-Null
    New-Item -ItemType Directory -Path $helpOutPath -Force | Out-Null

    Update-MarkdownHelp -Path $docsPath -Force | Out-Null

    New-ExternalHelp -Path $docsPath -OutputPath $helpOutPath -Force | Out-Null

    Write-Host "  Markdown : $docsPath" -ForegroundColor Green
    Write-Host "  MAML XML : $helpOutPath" -ForegroundColor Green
}

function Assert-PesterAvailable {
    if (-not (Get-Module -ListAvailable Pester | Where-Object Version -ge '5.0')) {
        throw 'Pester 5.0 or later is required. Install with: Install-Module Pester -Scope CurrentUser -MinimumVersion 5.0'
    }
    Import-Module Pester -MinimumVersion 5.0 -Force
}

function Invoke-BuildTest {
    Write-Host 'Running unit tests...' -ForegroundColor Cyan
    Assert-PesterAvailable

    $config = New-PesterConfiguration
    $config.Run.Path             = "$testsPath/ServiceDesk.Cloud.Requests.Tests.ps1"
    $config.Filter.ExcludeTag    = @('Integration')
    $config.Output.Verbosity     = 'Detailed'
    $config.CodeCoverage.Enabled = $false

    $result = Invoke-Pester -Configuration $config

    if ($result.FailedCount -gt 0) {
        throw "$($result.FailedCount) unit test(s) failed."
    }

    Write-Host "  $($result.PassedCount) test(s) passed." -ForegroundColor Green
}

function Invoke-BuildIntegrationTest {
    Write-Host 'Running integration tests...' -ForegroundColor Cyan
    Assert-PesterAvailable

    if (-not $env:SDP_PORTAL_NAME) {
        throw 'SDP_PORTAL_NAME environment variable must be set to run integration tests.'
    }

    $config = New-PesterConfiguration
    $config.Run.Path             = "$testsPath/Integration"
    $config.Filter.Tag           = @('Integration')
    $config.Output.Verbosity     = 'Detailed'
    $config.CodeCoverage.Enabled = $false

    $result = Invoke-Pester -Configuration $config

    if ($result.FailedCount -gt 0) {
        throw "$($result.FailedCount) integration test(s) failed."
    }

    Write-Host "  $($result.PassedCount) integration test(s) passed." -ForegroundColor Green
}

function Invoke-BuildPackage {
    Write-Host 'Packaging module...' -ForegroundColor Cyan

    $version     = (Import-PowerShellDataFile $manifestPath).ModuleVersion
    $outDir      = "$PSScriptRoot/dist"
    $packagePath = "$outDir/$moduleName.$version.zip"

    New-Item -ItemType Directory -Path $outDir -Force | Out-Null

    $compress = @{
        Path            = $moduleRoot
        DestinationPath = $packagePath
        Force           = $true
    }
    Compress-Archive @compress

    Write-Host "  Package  : $packagePath" -ForegroundColor Green
}

$runAll = $Task -contains 'All'

if ($runAll -or $Task -contains 'Docs')            { Invoke-BuildDocs }
if ($runAll -or $Task -contains 'Test')            { Invoke-BuildTest }
if ($Task -contains 'IntegrationTest')             { Invoke-BuildIntegrationTest }
if ($runAll -or $Task -contains 'Package')         { Invoke-BuildPackage }

Write-Host 'Build complete.' -ForegroundColor Green
