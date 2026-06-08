#!/usr/bin/env bash
#
# pre-migration-backup.sh
# Run this ONCE on your Gentoo system before switching to CachyOS.
# It backs up everything needed so you can restore on the new system.
#
# Usage: bash files/backup-pre-migration.sh

set -e

BACKUP_DIR="${BACKUP_DIR:-/mnt/backup}"
BACKUP_DISK="${BACKUP_DISK:-/mnt/backup/gentoo-root-backup}"
DRY_RUN="${DRY_RUN:-false}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERR]${NC} $*"; }
info() { echo -e "      $*"; }

if [ "$DRY_RUN" = "true" ]; then
  warn "DRY RUN MODE — no files will be written"
fi

# ---------------------------------------------------------------------------
# 0. Verify backup disk is mounted
# ---------------------------------------------------------------------------
echo ""
echo "=============================================="
echo " Pre-Migration Backup Script"
echo "=============================================="
echo ""

if ! mountpoint -q "$BACKUP_DIR"; then
  err "Backup disk not mounted at $BACKUP_DIR"
  err "Mount it first, e.g.: sudo mount /dev/sdX1 $BACKUP_DIR"
  exit 1
fi
log "Backup disk is mounted at $BACKUP_DIR"

# ---------------------------------------------------------------------------
# 1. Package lists — regenerate fresh copies in the repo
# ---------------------------------------------------------------------------
echo ""
echo "--- Package Lists ---"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && cd .. && pwd)"
CACHYOS_DIR="$REPO_DIR/files/cachyos"

info "Updating Gentoo world file..."
cp /var/lib/portage/world "$REPO_DIR/files/gentoo/world"
log "Gentoo world file saved"

info "Regenerating flatpak list..."
flatpak list --app --columns=application > "$CACHYOS_DIR/pkglist-flatpak.txt" 2>/dev/null || true
log "Flatpak list saved"

info "Regenerating npm global list..."
npm list -g --depth=0 2>/dev/null | tail -n +2 | sed 's/[├└]─┬ //; s/[├└]── //' | awk '{print $2}' | sort > "$CACHYOS_DIR/pkglist-npm.txt" 2>/dev/null || true
log "NPM global list saved"

# ---------------------------------------------------------------------------
# 2. Whole-disk backup (EFI, /boot, root XFS)
# ---------------------------------------------------------------------------
echo ""
echo "--- Whole-Disk Backup -> $BACKUP_DISK ---"
mkdir -p "$BACKUP_DISK"

backup_efi_boot() {
  info "Backing up /efi (vfat)..."
  if [ "$DRY_RUN" = "true" ]; then
    info "  dry-run: tar -czf $BACKUP_DISK/efi_backup.tar.gz /efi"
  else
    sudo tar -czf "$BACKUP_DISK/efi_backup.tar.gz" /efi
    log "/efi backed up ($(du -sh "$BACKUP_DISK/efi_backup.tar.gz" | cut -f1))"
  fi

  info "Backing up /boot (vfat)..."
  if [ "$DRY_RUN" = "true" ]; then
    info "  dry-run: tar -czf $BACKUP_DISK/boot_backup.tar.gz /boot"
  else
    sudo tar -czf "$BACKUP_DISK/boot_backup.tar.gz" /boot
    log "/boot backed up ($(du -sh "$BACKUP_DISK/boot_backup.tar.gz" | cut -f1))"
  fi
}

backup_root_xfs() {
  info "Backing up / (XFS root) with xfsdump..."
  info "  This may take a while. Excludes: /mnt, /tmp, /proc, /sys, /dev, /run"

  if [ "$DRY_RUN" = "true" ]; then
    info "  dry-run: xfsdump -l 0 -f $BACKUP_DISK/root-backup.dump /"
    return
  fi

  # xfsdump needs the filesystem to be XFS
  if ! df -T / | grep -q xfs; then
    err "/ is not XFS — xfsdump won't work. Use rsync or tar instead."
    return 1
  fi

  sudo xfsdump -l 0 -f "$BACKUP_DISK/root-backup.dump" /
  log "/ backed up with xfsdump"
}

backup_efi_boot
backup_root_xfs

# ---------------------------------------------------------------------------
# 3. Firefox profile
# ---------------------------------------------------------------------------
echo ""
echo "--- Browser Profiles -> $BACKUP_DIR ---"

info "Backing up Firefox profile (dnv2hknk.default-release)..."
if [ -d "$HOME/.mozilla/firefox/dnv2hknk.default-release" ]; then
  if [ "$DRY_RUN" = "true" ]; then
    info "  dry-run: tar -czf $BACKUP_DIR/firefox.tar.gz ~/.mozilla/firefox/dnv2hknk.default-release ~/.mozilla/firefox/profiles.ini ~/.mozilla/firefox/installs.ini"
  else
    tar -czf "$BACKUP_DIR/firefox.tar.gz" \
      -C "$HOME" \
      .mozilla/firefox/dnv2hknk.default-release \
      .mozilla/firefox/profiles.ini \
      .mozilla/firefox/installs.ini
    log "Firefox backed up ($(du -sh "$BACKUP_DIR/firefox.tar.gz" | cut -f1))"
  fi
else
  warn "Firefox profile dnv2hknk.default-release not found — skipping"
fi

# ---------------------------------------------------------------------------
# 4. Credentials
# ---------------------------------------------------------------------------
echo ""
echo "--- Credentials -> $BACKUP_DIR ---"
info "WARNING: These archives contain private keys and credentials."
info "         Store them securely. Delete after restoring on the new system."

backup_archive() {
  local name="$1"
  shift
  local dest="$BACKUP_DIR/${name}.tar.gz"

  if [ "$DRY_RUN" = "true" ]; then
    info "  dry-run: tar -czf $dest $*"
    return
  fi

  tar -czf "$dest" -C "$HOME" "$@"
  sudo chmod 600 "$dest"
  log "$name backed up ($(du -sh "$dest" | cut -f1))"
}

backup_archive "ssh"      .ssh
backup_archive "gnupg"    .gnupg
backup_archive "aws-kube" .aws .kube .docker/config.json 2>/dev/null || true

# ---------------------------------------------------------------------------
# 5. Large application configs
# ---------------------------------------------------------------------------
echo ""
echo "--- Application Configs -> $BACKUP_DIR ---"

backup_archive "vscode"        .config/Code/User
backup_archive "easyeffects"   .config/easyeffects
backup_archive "gimp"          .config/GIMP
backup_archive "obs-studio"    .config/obs-studio
backup_archive "blender"       .config/blender
backup_archive "krita"         .config/kritarc .config/kritadisplayrc
backup_archive "inkscape"      .config/inkscape
backup_archive "audacity"      .config/audacity
backup_archive "wireshark"     .config/wireshark

# ---------------------------------------------------------------------------
# 6. Optional: other configs worth backing up but too large for git
# ---------------------------------------------------------------------------
echo ""
echo "--- Optional Extras -> $BACKUP_DIR ---"

backup_archive "chromium"      .config/chromium/Default 2>/dev/null || warn "chromium profile not found — skipped"
backup_archive "google-chrome" .config/google-chrome/Default 2>/dev/null || warn "google-chrome profile not found — skipped"

# ---------------------------------------------------------------------------
# 7. Verify dotfiles repo is pushed to GitHub
# ---------------------------------------------------------------------------
echo ""
echo "--- Dotfiles Repo ---"

cd "$REPO_DIR"
if git remote get-url origin &>/dev/null; then
  info "Remote: $(git remote get-url origin)"
  if git status --porcelain | grep -q '^[MARCD]'; then
    warn "Dotfiles repo has uncommitted changes:"
    git status --short
    warn "Commit and push before migrating!"
  else
    log "Dotfiles repo is clean"
  fi

  info "Recent commits:"
  git log --oneline -5
else
  warn "No git remote found"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "=============================================="
echo " Backup Complete"
echo "=============================================="
echo ""
echo "Backups stored under $BACKUP_DIR/:"
[ "$DRY_RUN" != "true" ] && ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || true
echo ""
if [ -d "$BACKUP_DISK" ]; then
  echo "Whole-disk backups stored under $BACKUP_DISK/:"
  [ "$DRY_RUN" != "true" ] && ls -lh "$BACKUP_DISK/" 2>/dev/null || true
fi
echo ""
echo "NEXT STEPS (see MIGRATION.md):"
echo "  1. Review the package lists in files/cachyos/"
echo "  2. Commit and push dotfiles: git add -A && git commit && git push"
echo "  3. Install CachyOS"
echo "  4. Clone dotfiles, run ./sync.sh, install packages"
echo "  5. Unlock git-crypt, restore from $BACKUP_DIR/"
echo ""
