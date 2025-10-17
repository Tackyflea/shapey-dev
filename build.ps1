param(
    [Parameter(Mandatory=$true)]
    [Alias("v")]
    [string]$Version,
    
    [Parameter(Mandatory=$false)]
    [string]$Repo = "Tackyflea/shapey", 
    
  [Parameter(Mandatory=$false)]
    [string]$BuildPath = "build/windows/x64/runner/Release",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "releases"
)

# Display banner
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "  Windows Build Release Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Configuration
$fullVersion = if ($Version.StartsWith("v")) { $Version } else { "v$Version" }
$zipName = "shapey-windows-$fullVersion.zip"
$zipPath = Join-Path $OutputFolder $zipName

Write-Host "`nVersion: $fullVersion" -ForegroundColor Green
Write-Host "Repository: $Repo" -ForegroundColor Green
Write-Host "Output: $zipPath`n" -ForegroundColor Green

# Create output folder if it doesn't exist
if (-not (Test-Path $OutputFolder)) {
    Write-Host "Creating output folder: $OutputFolder" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# Check if build path exists
if (-not (Test-Path $BuildPath)) {
    Write-Host "ERROR: Build path not found: $BuildPath" -ForegroundColor Red
    Write-Host "Please build your project first or check the path.`n" -ForegroundColor Yellow
    exit 1
}

# Check if gh CLI is installed
try {
    gh --version | Out-Null
} catch {
    Write-Host "ERROR: GitHub CLI (gh) is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Install from: https://cli.github.com/`n" -ForegroundColor Yellow
    exit 1
}

# Remove existing zip if it exists
if (Test-Path $zipPath) {
    Write-Host "Removing existing archive..." -ForegroundColor Yellow
    Remove-Item $zipPath -Force
}

# Create zip archive
Write-Host "Creating archive..." -ForegroundColor Yellow
try {
    Compress-Archive -Path "$BuildPath\*" -DestinationPath $zipPath -CompressionLevel Optimal
    $zipSize = (Get-Item $zipPath).Length / 1MB
    Write-Host "Archive created successfully! Size: $([math]::Round($zipSize, 2)) MB" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to create archive" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Set default notes if not provided
$Notes = "Release $fullVersion"

# Create GitHub release
Write-Host "`nCreating GitHub release..." -ForegroundColor Yellow
try {
    gh release create $fullVersion $zipPath -R $Repo --notes $Notes --generate-notes=false
    
    # Note: GitHub automatically includes source code archives
    # These cannot be removed via gh CLI, but your build zip is the main asset
    
    Write-Host "`nSUCCESS! Release created successfully!" -ForegroundColor Green
    Write-Host "View at: https://github.com/$Repo/releases/tag/$fullVersion" -ForegroundColor Cyan
    Write-Host "Local copy: $zipPath" -ForegroundColor Cyan
    Write-Host "`nNote: GitHub auto-generates source code archives." -ForegroundColor Yellow
    Write-Host "Your build is: shapey-live-windows-$fullVersion.zip`n" -ForegroundColor Yellow
} catch {
    Write-Host "ERROR: Failed to create GitHub release" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "`nThe zip file was created but the release failed." -ForegroundColor Yellow
    Write-Host "You can manually upload it or fix the error and retry.`n" -ForegroundColor Yellow
    exit 1
}