Param(
  [string]$Workspace = "",
  [string]$SharedPath = "",
  [string]$Target = "",
  [ValidateSet("vscode","jetbrains","eclipse")]
  [string]$Ide = "",
  [switch]$NonInteractive
)

# install-auto.ps1
# Auto-detect preferred installer on Windows; fallback prompt to ask terminal.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PsInstaller = Join-Path $ScriptDir "install-shared-instructions.ps1"
$ShInstaller = Join-Path $ScriptDir "install-shared-instructions.sh"

function Has-Exe($name) {
  $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

# If running in native PowerShell, prefer PowerShell installer
if ($PSVersionTable -and (Has-Exe "powershell" -or Has-Exe "pwsh")) {
  & $PsInstaller -Workspace $Workspace -SharedPath $SharedPath -Target $Target -Ide $Ide -NonInteractive:$NonInteractive
  exit 0
}

# Fallback: Ask the user
Write-Host "Could not auto-detect terminal."
Write-Host "Which terminal are you using?"
Write-Host "  a) PowerShell"
Write-Host "  b) Bash/zsh (Git Bash)"
$ans = Read-Host "Enter choice [a/b]"
switch -Regex ($ans) {
  '^[Aa]$' {
    & $PsInstaller -Workspace $Workspace -SharedPath $SharedPath -Target $Target -Ide $Ide -NonInteractive:$NonInteractive
  }
  '^[Bb]$' {
    if (Has-Exe "bash") {
      bash -lc "'$ShInstaller'"
    } else {
      Write-Error "bash not found. Please run the PowerShell installer instead."
    }
  }
  default { Write-Error "Invalid choice" }
}
