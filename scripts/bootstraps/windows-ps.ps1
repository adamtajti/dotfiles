# I assume that the dotfiles directory will be checkout out already at this point.
# Which means that WSL was bootstrapped somehow else.

# Set ErrorAction to 'Stop' to make the script exit on the first error
$ErrorActionPreference = "Stop"

Write-Host $PSScriptRoot

# Source the function that will be used throughout the scripts
. (Join-Path $PSScriptRoot "functions.ps1")

# Setting up an Unrestricted Execution Policty profile. I want the "bash experience".
# NOTE: This will require administrative permissions for the first time.
Set-Unrestricted-ExecutionPolicy

Initialize-Home-Config-Directory

# Filters for PowerToys Run
# Set-FileHidden -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" # This doesn't work even with admin priviliges
Set-FileHidden -FilePath "C:\Users\adamt\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
Set-FileHidden -FilePath "C:\Users\adamt\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell (x86).lnk"

# Enable support for long paths in Windows (recommended by Komorebi)
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

# Install Scoop (yet another Package Manager).
Install-Scoop

# Git is required to be installed before setting up the buckets.
Install-Scoop-Package -PackageName "git"

# Adds the main bucket (if needed) for: 1password-cli, act, air, ast-grep, dive, fd, gcc, gh,
# git-crypt, jq, yq, netcat, ripgrep...
Install-Scoop-Bucket -BucketName "main"
# Adds the extras bucket (if needed) for: alacritty, vscode, spotify, caprine, 
# processhacker, aida64extreme, cpu-z, altdrag, anki, audacity, chatterino,
# foobar2000, powertoys ...
Install-Scoop-Bucket -BucketName "extras"
# Adds the versions bucket (if needed) for steam, brave-nightly, neovim, ...
Install-Scoop-Bucket -BucketName "versions"

# Install Scoop packages
Install-Scoop-Package -PackageName "steam"
Install-Scoop-Package -PackageName "alacritty"
Install-Scoop-Package -PackageName "autohotkey" # this might be utilized by Komorebi as well
Install-Scoop-Package -PackageName "neovim" # my main driver (neovim-nightly had some has mismatch issues)
Install-Scoop-Package -PackageName "vscode" # additional editor
Install-Scoop-Package -PackageName "spotify" # main driver
Install-Scoop-Package -PackageName "caprine" # messenger alternative, this is quite broken as well, I'm not switching just yet.
# Install-Scoop-Package -PackageName "discord" # cloud streaming music <- This was really broken, I'll just install Discord myself.
Install-Scoop-Package -PackageName "processhacker" # (processhacker-nightly didn't work)
Install-Scoop-Package -PackageName "1password-cli"
Install-Scoop-Package -PackageName "act" # to test gha workflows

Install-Scoop-Package -PackageName "aida64extreme" # not sure about this yet
Install-Scoop-Package -PackageName "cpu-z" # not sure about this yet

Install-Scoop-Package -PackageName "air" # live-reloading cli to dev go apps
Install-Scoop-Package -PackageName "altdrag" # https://stefansundin.github.io/altdrag/
Install-Scoop-Package -PackageName "anki" # flash cards
Install-Scoop-Package -PackageName "ast-grep" # https://ast-grep.github.io
Install-Scoop-Package -PackageName "brave-nightly" # browser of choice
Install-Scoop-Package -PackageName "audacity" # sound edits, clips
Install-Scoop-Package -PackageName "chatterino" # twitch chat
Install-Scoop-Package -PackageName "dive" # analyze docker image layers
Install-Scoop-Package -PackageName "fd" # find files faster (respects .gitignore)
Install-Scoop-Package -PackageName "foobar2000" # traditional music (files + radios)
Install-Scoop-Package -PackageName "gcc" # c compiler
Install-Scoop-Package -PackageName "gh" # GitHub CLI
Install-Scoop-Package -PackageName "git-crypt" # handling ecrypted files in semi-public repos
Install-Scoop-Package -PackageName "jq" # processing JSON outputs
Install-Scoop-Package -PackageName "yq" # processing YAML outputs
Install-Scoop-Package -PackageName "netcat" # the good old nc for network testing
Install-Scoop-Package -PackageName "ripgrep" # search for text, faster
Install-Scoop-Package -PackageName "powertoys" # using PowerToy Run launcher for now

# Update all the packages that were previously installed
Update-Scoop
 
# Detect errors during the run. I don't have the need for more error handling yet.
if ($ScriptErrors) {
    Write-Host "An error occurred. Script will exit."
}
