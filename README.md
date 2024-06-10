# dotfiles

These are my personal dotfiles, which I use to configure my system. The main goal is to have a consistent setup across all of my devices. The configuration files are stored in this git repository and are linked to the correct location on the system with the help of [anishathalye/dotbot](https://github.com/anishathalye/dotbot).

I'm also utilizing a couple of plugins and applications to further enchance what I can do with this. The ones that pop into my mind are:

- [dotbot-includes](https://github.com/vanduc2514/dotbot-includes/tree/master): Enables to include base configurations.

## Usual Run

There are two scripts to choose from. [./scripts/setup.sh](./scripts/setup.sh) can be used where Bash is available, while [./scripts/setup.ps1](./scripts/setup.ps1) can be used with Powershell (on Windows, lol). The Bash script should detect the correct OS and based on that it should load the correct configuration and setup the system to the best of its abilities.

## First Run on a New System

The first run on a new system is always a bit awkward. I have a collection of scripts to ease with this at [./scripts/bootstraps](./scripts/bootstraps/). The following instructions should be followed depending on the OS:

### Windows

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
