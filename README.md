# dotfiles

These are my personal dotfiles, which are used to initialize and maintain the system. Run `./sync.sh` to initialize or sync your system.

## First Run on a New System

The first run on a new system is always a bit awkward. I have a collection of scripts to ease with this at [./scripts/bootstraps](./scripts/bootstraps/). The following instructions should be followed depending on the OS:

### Windows

> [!NOTE]  
> It's been a while since I've been on Windows, although I'm planning to install one soon. I'll update the procedure when I do it.

The first installation will be awkward over here as well in the beginning:

1. Setup the base Windows system (Brave, Dropbox, KeePassXC)
1. Run the `./scripts/bootstraps/windows-wsl.sh`.
1. Run the following snippet in Powershell with administrative rights:

   ```powershell
   # Note: This assumes that you have clones the dotfiles in WSL already.
   # The orders of these steps might change. As this should aid to setup the base system.
   # So this might be the second step to take with an archive downlod from GitHub.
   cd \\wsl.localhost\Ubuntu\home\adamtajti\GitHub\dotfiles\;
   powershell.exe -executionpolicy bypass -file .\bootstraps\windows-ps.ps1;
   ```
