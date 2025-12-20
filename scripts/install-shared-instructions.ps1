Param(
  [string]$Workspace = "",
  [string]$SharedPath = "",
  [string]$Target = "",
  [ValidateSet("vscode","jetbrains","eclipse")]
  [string]$Ide = "",
  [switch]$NonInteractive
)

# install-shared-instructions.ps1
# Interactive Windows installer:
# 1) Pick repo
# 2) Create shared-instructions link (SymbolicLink or Junction)
# 3) Choose IDE
# 4) Run init script (Windows variants where applicable)

$ErrorActionPreference = "Stop"

# Resolve shared and workspace defaults
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DefaultShared = Resolve-Path -Path (Join-Path $ScriptDir "..") | Select-Object -ExpandProperty Path
$DefaultWorkspace = Resolve-Path -Path (Join-Path $DefaultShared "..") | Select-Object -ExpandProperty Path

if ([string]::IsNullOrWhiteSpace($SharedPath)) { $SharedPath = $DefaultShared }
if ([string]::IsNullOrWhiteSpace($Workspace)) { $Workspace = $DefaultWorkspace }

try { $SharedAbs = Resolve-Path -Path $SharedPath | Select-Object -ExpandProperty Path } catch { Write-Error "shared-instructions not found: $SharedPath" }
try { $WorkspaceAbs = Resolve-Path -Path $Workspace | Select-Object -ExpandProperty Path } catch { Write-Error "workspace not found: $Workspace" }

Write-Host "Using shared-instructions: $SharedAbs"
Write-Host "Scanning workspace:       $WorkspaceAbs"

# Collect candidate repos
$candidates = Get-ChildItem -Path $WorkspaceAbs -Directory | Where-Object {
  $_.Name -ne "shared-instructions" -and $_.Name -ne ".git" -and (
    Test-Path (Join-Path $_.FullName ".git") -or
    Test-Path (Join-Path $_.FullName "package.json") -or
    Test-Path (Join-Path $_.FullName "pom.xml") -or
    Test-Path (Join-Path $_.FullName "src")
  )
}

# Select repo
if ($NonInteractive) {
  if ([string]::IsNullOrWhiteSpace($Target)) { Write-Error "--NonInteractive requires --Target <repo-path>" }
  try { $TargetAbs = Resolve-Path -Path $Target | Select-Object -ExpandProperty Path } catch { Write-Error "target repo not found: $Target" }
} else {
  Write-Host "Found repos:"
  $i = 1
  foreach ($c in $candidates) {
    Write-Host "  [$i] $($c.Name) -> $($c.FullName)"
    $i++
  }
  Write-Host "  [C] Custom path"
  $choice = Read-Host "Select a repo number or 'C'"
  if ($choice -match '^[Cc]$') {
    $custom = Read-Host "Enter absolute path to repo"
    try { $TargetAbs = Resolve-Path -Path $custom | Select-Object -ExpandProperty Path } catch { Write-Error "path not found: $custom" }
  } elseif ($choice -match '^[0-9]+$') {
    $idx = [int]$choice
    if ($idx -lt 1 -or $idx -gt $candidates.Count) { Write-Error "selection out of range" }
    $TargetAbs = $candidates[$idx-1].FullName
  } else {
    Write-Error "invalid selection"
  }
}

$RepoName = Split-Path -Leaf $TargetAbs
$LinkTarget = Join-Path $TargetAbs "shared-instructions"

# Progress message
Write-Host "running.... script add sym link path for Repo: $TargetAbs"

# Create or update link
function Ensure-Link {
  param([string]$Path, [string]$Target)
  if (Test-Path -Path $Path -PathType Leaf -or Test-Path -Path $Path -PathType Container) {
    # Remove file/dir/symlink/junction
    try { Remove-Item -Path $Path -Force -Recurse } catch {}
  }
  # Try symbolic link
  try {
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
    return "SymbolicLink"
  } catch {
    # Fallback: junction (dir only)
    try {
      New-Item -ItemType Junction -Path $Path -Target $Target | Out-Null
      return "Junction"
    } catch {
      return $null
    }
  }
}

$linkType = Ensure-Link -Path $LinkTarget -Target $SharedAbs
if ($null -eq $linkType) {
  Write-Warning "Failed to create symlink/junction. Enable Developer Mode, or run PowerShell as Administrator."
  Write-Error "Link setup failed."
}
Write-Host "Created $linkType in $RepoName -> $SharedAbs"

# IDE selection
if (-not $NonInteractive) {
  Write-Host "IDE option choose"
  Write-Host "  a. VScode"
  Write-Host "  b. jetbrain"
  Write-Host "  c.  eclipse"
  $ans = Read-Host "Enter choice [a/b/c]"
  switch -Regex ($ans) {
    '^[Aa]$' { $Ide = "vscode" }
    '^[Bb]$' { $Ide = "jetbrains" }
    '^[Cc]$' { $Ide = "eclipse" }
    default  { Write-Error "invalid IDE choice" }
  }
}

switch ($Ide) {
  "vscode" {
    $vsInit = Join-Path $SharedAbs "scripts/init-shared-instructions-vscode.ps1"
    if (Test-Path $vsInit) {
      Write-Host "Running VS Code init in $RepoName..."
      Push-Location $TargetAbs
      try { & $vsInit -SharedPath $SharedAbs -NonInteractive } finally { Pop-Location }
    } else { Write-Error "VS Code init script not found: $vsInit" }
  }
  "jetbrains" {
    # Minimal linking of JetBrains profiles if present
    $codeStyleSrc = Join-Path $SharedAbs "jetbrains/codeStyles/Project.xml"
    $codeStyleDst = Join-Path $TargetAbs ".idea/codeStyles/Project.xml"
    $inspectSrc   = Join-Path $SharedAbs "jetbrains/inspectionProfiles/Project_Default.xml"
    $inspectDst   = Join-Path $TargetAbs ".idea/inspectionProfiles/Project_Default.xml"
    New-Item -ItemType Directory -Path (Split-Path $codeStyleDst) -Force | Out-Null
    New-Item -ItemType Directory -Path (Split-Path $inspectDst) -Force | Out-Null
    if (Test-Path $codeStyleSrc) { Ensure-Link -Path $codeStyleDst -Target $codeStyleSrc | Out-Null; Write-Host "Linked JetBrains CodeStyle" }
    if (Test-Path $inspectSrc)   { Ensure-Link -Path $inspectDst   -Target $inspectSrc   | Out-Null; Write-Host "Linked JetBrains InspectionProfile" }
  }
  "eclipse" {
    $settingsSrc = Join-Path $SharedAbs "eclipse/.settings"
    $projectSrc  = Join-Path $SharedAbs "eclipse/.project"
    $settingsDst = Join-Path $TargetAbs ".settings"
    $projectDst  = Join-Path $TargetAbs ".project"
    if (Test-Path $settingsSrc) { Ensure-Link -Path $settingsDst -Target $settingsSrc | Out-Null; Write-Host "Linked Eclipse .settings" }
    if (Test-Path $projectSrc)  { Ensure-Link -Path $projectDst  -Target $projectSrc  | Out-Null; Write-Host "Linked Eclipse .project" }
  }
  default {
    Write-Error "Specify --Ide <vscode|jetbrains|eclipse> with --NonInteractive or choose interactively."
  }
}

Write-Host "installation progress ..... ready!"
