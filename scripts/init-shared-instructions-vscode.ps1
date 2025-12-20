Param(
  [string]$SharedPath = "../shared-instructions",
  [switch]$NonInteractive
)

# init-shared-instructions-vscode.ps1
# Creates/merges .vscode/settings.json to include Copilot instructions on Windows.

$ErrorActionPreference = "Stop"

# Resolve shared path
try {
  $SharedAbs = Resolve-Path -Path $SharedPath | Select-Object -ExpandProperty Path
} catch {
  Write-Error "shared-instructions path not found: $SharedPath"
}

# Ensure .vscode
$settingsDir = ".vscode"
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir | Out-Null }

$settingsFile = Join-Path $settingsDir "settings.json"
$pathToAdd = "shared-instructions/instructions/copilot.instructions.md"

# Load existing JSON (if any)
$existing = @{}
if (Test-Path $settingsFile) {
  try {
    $existing = Get-Content $settingsFile -Raw | ConvertFrom-Json
  } catch {
    $existing = @{}
  }
}

# Merge copilot.instructions
$instructions = $existing."copilot.instructions"
if ($instructions -is [System.Collections.IEnumerable]) {
  $paths = @($instructions)
  if (-not ($paths -contains $pathToAdd)) { $paths += $pathToAdd }
  $existing."copilot.instructions" = $paths
} else {
  $existing."copilot.instructions" = @($pathToAdd)
}

# Write JSON back
$existing | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
Write-Host "Merged copilot.instructions into $settingsFile"
