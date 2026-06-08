# Gentoo → CachyOS Migration Guide

## Pre-Migration (on Gentoo, before wiping)

### 1. Run the pre-migration backup script

```bash
# Make sure your backup disk is mounted
mountpoint /mnt/backup || sudo mount /dev/sdXN /mnt/backup

# Dry-run first to see what will happen
DRY_RUN=true bash ~/GitHub/dotfiles/files/backup-pre-migration.sh

# Run for real
bash ~/GitHub/dotfiles/files/backup-pre-migration.sh
```

This script backs up:
- Whole disk: `/efi` (tar), `/boot` (tar), `/` (xfsdump) → `/mnt/backup/gentoo-root-backup/`
- Firefox profile with cookies/sessions → `/mnt/backup/firefox.tar.gz`
- SSH keys → `/mnt/backup/ssh.tar.gz`
- GPG keys (needed for git-crypt) → `/mnt/backup/gnupg.tar.gz`
- AWS & Kubernetes configs → `/mnt/backup/aws-kube.tar.gz`
- VS Code settings → `/mnt/backup/vscode.tar.gz`
- Large app configs (GIMP, OBS, Blender, Krita, Inkscape, Audacity, etc.)
- Updates and regenerates package lists in `files/cachyos/`

### 2. Verify and push dotfiles

```bash
cd ~/GitHub/dotfiles

# Review package lists — adjust Arch package names if needed
cat files/cachyos/pkglist-pacman.txt
cat files/cachyos/pkglist-aur.txt

# Check git status
git status

# Add all new files
git add files/.zprofile files/.bashrc files/.zsh_plugins.txt files/.rtorrent.rc
git add files/.config/ghostty files/.config/helix files/.config/btop files/.config/htop
git add files/.config/flameshot files/.config/qt5ct files/.config/qt6ct
git add files/.config/easyeffects files/.config/xsettingsd files/.config/weechat
git add files/.config/opensnitch files/.config/wireshark files/.config/nwg-look
git add files/.config/gtk-3.0 files/.config/user-dirs.dirs files/.config/mimeapps.list
git add files/cachyos/ files/backup-pre-migration.sh
git add scripts/bootstrappers/cachyos.sh scripts/syncs/cachyos.sh

git commit -m "Add CachyOS/Arch support + backup configs for Gentoo migration"
git push

# Verify encrypted files are still encrypted
git-crypt status -e
```

### 3. Optional: save your git-crypt key

If you don't have a copy of your git-crypt symmetric key somewhere accessible:

```bash
git-crypt export-key /mnt/backup/git-crypt-key
```

---

## Installation (CachyOS)

### 4. Install CachyOS

Follow the [CachyOS installation guide](https://wiki.cachyos.org/). During installation:
- Use the same username as on Gentoo (`adamtajti`)
- For filesystem, consider XFS again if you want xfsrestore support for the old root

### 5. After first boot — install basics and dotfiles

```bash
# Install essentials
sudo pacman -S git base-devel

# Clone dotfiles
mkdir -p ~/GitHub
git clone git@github.com:adamtajti/dotfiles.git ~/GitHub/dotfiles
cd ~/GitHub/dotfiles

# Run sync (creates symlinks for all configs)
./sync.sh
```

### 6. Install packages

```bash
# Install AUR helper (paru)
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru && makepkg -si && cd ~/GitHub/dotfiles

# Install official packages
sudo pacman -S --needed - < files/cachyos/pkglist-pacman.txt

# Install AUR packages
paru -S --needed - < files/cachyos/pkglist-aur.txt

# Install flatpak apps
xargs -a files/cachyos/pkglist-flatpak.txt flatpak install -y

# Install global npm packages (if any)
xargs -a files/cachyos/pkglist-npm.txt npm install -g
```

**Note:** The package lists were auto-generated from your Gentoo world file. Some package names may differ on Arch. Install in batches and fix any missing packages manually.

### 7. Unlock encrypted files

```bash
# If you have a symmetric key file:
git-crypt unlock /path/to/git-crypt-key

# If you use GPG (check with: git-crypt status):
# Import your GPG keys first (see below), then:
git-crypt unlock
```

---

## Restoration (from `/mnt/backup/`)

### 8. Mount backup disk and restore

```bash
sudo mount /dev/sdXN /mnt/backup

# Firefox profile (cookies, sessions, extensions, bookmarks)
tar -xzf /mnt/backup/firefox.tar.gz -C ~/

# SSH keys — CRITICAL: fix permissions
tar -xzf /mnt/backup/ssh.tar.gz -C ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub

# GPG keys — CRITICAL: needed for git-crypt unlock
tar -xzf /mnt/backup/gnupg.tar.gz -C ~/
chmod 700 ~/.gnupg

# AWS, Kubernetes, Docker configs
tar -xzf /mnt/backup/aws-kube.tar.gz -C ~/

# VS Code settings
tar -xzf /mnt/backup/vscode.tar.gz -C ~/

# Large app configs (optional — restore only what you need)
tar -xzf /mnt/backup/easyeffects.tar.gz -C ~/
tar -xzf /mnt/backup/gimp.tar.gz -C ~/
tar -xzf /mnt/backup/obs-studio.tar.gz -C ~/
tar -xzf /mnt/backup/krita.tar.gz -C ~/
tar -xzf /mnt/backup/inkscape.tar.gz -C ~/
tar -xzf /mnt/backup/audacity.tar.gz -C ~/
tar -xzf /mnt/backup/wireshark.tar.gz -C ~/
```

### 9. Selective restore from XFS dump (if needed)

If you need to recover files from your old Gentoo root:

```bash
# Interactive mode — browse and select files to restore
sudo xfsrestore -i /mnt/backup/gentoo-root-backup/root-backup.dump /tmp/gentoo-root/

# Or restore a specific directory
sudo xfsrestore -s etc/nginx /mnt/backup/gentoo-root-backup/root-backup.dump /tmp/gentoo-root/

# Or restore everything (if you moved the old root partition)
# sudo xfsrestore /mnt/backup/gentoo-root-backup/root-backup.dump /mnt/old-gentoo/
```

---

## Post-Migration Verification

Run these checks after restoration:

```bash
# SSH to GitHub works
ssh -T git@github.com

# GPG keys are available
gpg --list-secret-keys

# git-crypt works
cd ~/GitHub/dotfiles && git-crypt status -e

# Firefox sessions intact (launch Firefox)
firefox

# Shell config loads without errors
zsh

# Neovim works with plugins
nvim --headless +'Lazy! sync' +qa

# systemd user services
systemctl --user status pipewire.service
```

---

## What's NOT Automated

These steps must be done manually or are outside the dotfiles repo:

| What | Why |
|---|---|
| **Package list review** | Arch package names differ from Gentoo. The generated lists are a best-effort mapping — review and adjust before installing. |
| **CachyOS ISO installation** | Follow the CachyOS installer. Choose your partitioning, username, locale, etc. |
| **XFS dump selective restore** | Only needed if you want to pull files from the old Gentoo root. Run `xfsrestore -i` interactively. |
| **git-crypt key management** | The key file is not in this repo. Export it before migration with `git-crypt export-key`. |
| **SSH key passphrases** | If your SSH keys have passphrases, you'll need to enter them after restore. |
| **Browser profiles beyond Firefox** | Chrome/Chromium/Brave profiles were backed up to `/mnt/backup/` but not heavily tested. Restore them manually if needed. |
| **Obsidian vaults** | If your notes are stored as local Markdown files, sync them separately (Git, Syncthing, Dropbox, etc.). |
| **Flatpak data** | Flatpak app data lives in `~/.var/app/` — back that up separately if you need app-local state. |
| **Docker images/containers** | Docker images are not backed up. Re-pull or rebuild them. Volumes in `~/.docker/` are backed up. |
| **Cron jobs / systemd timers** | No user crontab or timers were found, but check `crontab -l` and `systemctl --user list-timers` before wiping. |
| **Wine prefixes** | `~/.wine/` and game prefixes are large. Back up manually or reinstall games. |
| **Steam library** | Steam games in `~/.local/share/Steam/` are huge. Either back up the entire directory or re-download. |

---

## Encrypted Files in Dotfiles (git-crypt)

These files are encrypted in the repo and will only be readable after `git-crypt unlock`:
- Work/Tulip shell configs and scripts (`.config/shell/tulip.sh`, `t-*` scripts)
- Opencode Tulip config (`.config/opencode-tulip/`)
- Neovim work plugins (`.config/nvim/lua/work/`)
- KeePassXC config (`.config/keepassxc/`)
- MPD & ncmpcpp configs (`.config/mpd/`, `.config/ncmpcpp/`)
- Sway config (`.config/sway/`)
- Qutebrowser bookmarks (`.config/qutebrowser/bookmarks/`)
- Hetzner server configs (`.hetzner/`)
- Gentoo system configs (`.gentoo/etc/nginx/`, ddclient, login.defs)
- Nix netrc, npmrc
- Weechat config (IRC passwords) — **newly added**
- Personal private shell functions (`.config/shell/personal-private.sh`)
- Various fonts and reproductions

**Make sure you have `git-crypt` installed and the key accessible before the migration.**

---

## Cleanup After Successful Migration

Once everything is verified working on CachyOS:

```bash
# Remove sensitive backups from /mnt/backup/
rm /mnt/backup/ssh.tar.gz
rm /mnt/backup/gnupg.tar.gz
rm /mnt/backup/aws-kube.tar.gz

# Optionally remove the whole-disk backup (keep it until you're sure)
# rm /mnt/backup/gentoo-root-backup/*
```

You may want to keep `firefox.tar.gz` and `vscode.tar.gz` until you confirm those apps work.
