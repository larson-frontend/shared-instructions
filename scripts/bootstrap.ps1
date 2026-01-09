# PowerShell Bootstrap Script — Install shared-instructions in any project
#
# Usage:
#   irm https://raw.githubusercontent.com/YOUR_ORG/shared-instructions/main/scripts/bootstrap.ps1 | iex
#
# Or locally:
#   powershell -ExecutionPolicy Bypass -File path/to/bootstrap.ps1 [-RepoUrl URL] [-Branch BRANCH] [-Username USER]
#

param(
    [string]$RepoUrl = "https://github.com/YOUR_ORG/shared-instructions.git",
    [string]$Branch = "main",
    [string]$Username = "",
    [string]$TargetDir = ""
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }
function Write-Warning { Write-Host "⚠ $args" -ForegroundColor Yellow }

function Write-Header {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║     🚀 Shared Instructions Bootstrap Installer            ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not installed. Please install Git and try again."
        exit 1
    }
    
    Write-Success "All prerequisites met"
}

function Get-ProjectRoot {
    if ($TargetDir) {
        return $TargetDir
    }

    # Try git root
    try {
        $gitRoot = git rev-parse --show-toplevel 2>$null
        if ($gitRoot) {
            return $gitRoot
        }
    } catch {}

    # Look for project indicators
    $current = Get-Location
    while ($current.Path -ne $current.Root.Path) {
        if ((Test-Path "$current\package.json") -or 
            (Test-Path "$current\pom.xml") -or
            (Test-Path "$current\go.mod") -or
            (Test-Path "$current\.git")) {
            return $current.Path
        }
        $current = $current.Parent
    }

    return (Get-Location).Path
}

function Install-SharedInstructions {
    param([string]$ProjectRoot)
    
    $sharedParent = Split-Path -Parent $ProjectRoot
    $sharedPath = Join-Path $sharedParent "shared-instructions"

    Write-Info "Cloning shared-instructions..."
    
    if (Test-Path $sharedPath) {
        Write-Warning "shared-instructions already exists at: $sharedPath"
        Write-Info "Attempting to update..."
        
        Push-Location $sharedPath
        try {
            git pull origin $Branch | Out-Null
            Write-Success "Updated existing shared-instructions"
        } catch {
            Write-Warning "Could not update. Using existing version."
        }
        Pop-Location
    } else {
        try {
            git clone --branch $Branch $RepoUrl $sharedPath | Out-Null
            Write-Success "Cloned shared-instructions to: $sharedPath"
        } catch {
            Write-Error "Failed to clone shared-instructions from: $RepoUrl"
            exit 1
        }
    }

    return $sharedPath
}

function New-ProjectSymlink {
    param(
        [string]$ProjectRoot,
        [string]$SharedPath
    )
    
    $symlinkPath = Join-Path $ProjectRoot "shared-instructions"
    
    Write-Info "Creating symlink..."
    
    # Check if exists
    if (Test-Path $symlinkPath) {
        $item = Get-Item $symlinkPath
        if ($item.LinkType -eq "SymbolicLink") {
            Write-Success "Symlink already exists"
            return
        } else {
            Write-Error "Path exists but is not a symlink: $symlinkPath"
            Write-Info "Please remove it manually and try again"
            exit 1
        }
    }

    # Create symlink (requires Developer Mode or Admin rights)
    try {
        New-Item -ItemType SymbolicLink -Path $symlinkPath -Target "..\shared-instructions" | Out-Null
        Write-Success "Created symlink: $symlinkPath"
    } catch {
        Write-Warning "Could not create symlink. Trying to copy instead..."
        Copy-Item -Path $SharedPath -Destination $symlinkPath -Recurse
        Write-Success "Copied shared-instructions to project"
    }
}

function Initialize-VSCode {
    param(
        [string]$ProjectRoot,
        [string]$Username
    )
    
    Write-Info "Initializing VS Code settings..."
    
    $initScript = Join-Path $ProjectRoot "shared-instructions\scripts\init-shared-instructions-vscode.ps1"
    
    if (Test-Path $initScript) {
        $args = @("-NonInteractive")
        if ($Username) {
            $args += "-Username", $Username
        }
        
        try {
            & $initScript @args
            Write-Success "VS Code settings initialized"
        } catch {
            Write-Warning "VS Code initialization had issues (may be okay)"
        }
    } else {
        Write-Warning "VS Code init script not found"
    }
}

function Write-NextSteps {
    param([string]$ProjectRoot)
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  ✓ Installation Complete!                                 ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Project root: " -NoNewline
    Write-Host $ProjectRoot -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔧 Next Steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Reload VS Code:"
    Write-Host "     Ctrl+Shift+P → 'Reload Window'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  2. Start using the agent:"
    Write-Host "     Press Ctrl+I in any file" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  3. Read the docs:"
    Write-Host "     cat shared-instructions\docs\QUICK_SETUP.md" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Happy coding! 🚀" -ForegroundColor Green
    Write-Host ""
}

# Main execution
try {
    Write-Header
    Test-Prerequisites
    
    $projectRoot = Get-ProjectRoot
    Write-Info "Project root: $projectRoot"
    
    $sharedPath = Install-SharedInstructions -ProjectRoot $projectRoot
    New-ProjectSymlink -ProjectRoot $projectRoot -SharedPath $sharedPath
    Initialize-VSCode -ProjectRoot $projectRoot -Username $Username
    
    Write-NextSteps -ProjectRoot $projectRoot
    
} catch {
    Write-Error "Installation failed: $_"
    exit 1
}
