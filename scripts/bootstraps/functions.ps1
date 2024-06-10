function Assert-Administration-Principal {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run this script as an administrator to make registry changes."
        Write-Host "Right-click on the script file and select 'Run as administrator'."
        Exit 1
    }
}

function Set-FileHidden {
    param ([string]$FilePath)
    if (Test-Path -Path $FilePath -PathType Leaf) {
        Assert-Administration-Principal
        Write-Host "PowerToys-Run Filters: Attempting to make '$FilePath' hidden..."
        Set-ItemProperty -Path $FilePath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        Write-Host "PowerToys-Run Filters: File '$FilePath' is now hidden."
    }
    else {
        Write-Host "PowerToys-Run Filters: File '$FilePath' does not exist."
    }
}

function Initialize-Home-Config-Directory {
    mkdir $Env:USERPROFILE\.config -ea 0
}

function Set-Unrestricted-ExecutionPolicy {
    if ((Get-ExecutionPolicy -Scope CurrentUser) -ne "Unrestricted") {
        Assert-Administration-Principal
        Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    }
}

function Install-Scoop {
    if (-not (Test-Path "$Env:UserProfile\scoop\shims\scoop" -PathType Leaf)) { 
        Invoke-RestMethod get.scoop.sh | Invoke-Expression 
    }
}

function Update-Scoop {
    scoop update
}

function Install-Scoop-Package {
    param ([string]$PackageName)
    if (-not (scoop list | Select-String -Pattern "$PackageName")) { scoop install "$PackageName" }
}

function Install-Scoop-Bucket {
    param ([string]$BucketName)
    if (-not (scoop bucket list | Select-String -Pattern $BucketName)) { scoop bucket add "$BucketName" }
}
