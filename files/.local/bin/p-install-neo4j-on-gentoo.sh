#!/usr/bin/env bash
#
# Install Neo4j Community Edition on Gentoo from the official tarball.
# Based on https://neo4j.com/docs/operations-manual/current/installation/linux/tarball/
# (general Linux/Mac executable instructions — not the RHEL/Debian package flows).

set -euo pipefail

NEO4J_VERSION="2026.08.1"
NEO4J_DOWNLOAD_URL="https://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz"
NEO4J_HOME="/opt/neo4j-community-${NEO4J_VERSION}"
NEO4J_SYMLINK="/opt/neo4j"
DOWNLOAD_DIR=$(mktemp -d)

if [[ ${EUID} -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

cleanup() {
  rm -rf "${DOWNLOAD_DIR}"
}
trap cleanup EXIT

echo "==> Checking for Java 21 (required by Neo4j)"
if ! java -version 2>&1 | grep -q 'version "21\|version "25'; then
  echo "==> Java 21 not found, emerging dev-java/openjdk-bin:21"
  emerge --ask dev-java/openjdk-bin:21
  emerge --config dev-java/openjdk-bin:21
fi

echo "==> Downloading Neo4j ${NEO4J_VERSION}"
curl -fSL "${NEO4J_DOWNLOAD_URL}" -o "${DOWNLOAD_DIR}/neo4j-community-${NEO4J_VERSION}-unix.tar.gz"

echo "==> Unpacking"
tar zxf "${DOWNLOAD_DIR}/neo4j-community-${NEO4J_VERSION}-unix.tar.gz" -C "${DOWNLOAD_DIR}"

echo "==> Installing to ${NEO4J_HOME} and creating symlink ${NEO4J_SYMLINK}"
rm -rf "${NEO4J_HOME}"
mv "${DOWNLOAD_DIR}/neo4j-community-${NEO4J_VERSION}" "${NEO4J_HOME}"
ln -sfn "${NEO4J_HOME}" "${NEO4J_SYMLINK}"

echo "==> Creating neo4j user and group"
getent group neo4j >/dev/null || groupadd neo4j
getent passwd neo4j >/dev/null || useradd -g neo4j neo4j -s /bin/bash -d "${NEO4J_HOME}"

echo "==> Setting ownership"
chown -R neo4j:neo4j "${NEO4J_HOME}"

echo "==> Creating systemd service"
cat > /lib/systemd/system/neo4j.service <<'EOF'
[Unit]
Description=Neo4j Graph Database
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/neo4j/bin/neo4j console
Restart=on-abnormal
User=neo4j
Group=neo4j
Environment="NEO4J_CONF=/opt/neo4j/conf" "NEO4J_HOME=/opt/neo4j"
LimitNOFILE=60000
TimeoutSec=120

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable neo4j
echo "==> Start with: systemctl start neo4j"

echo "==> Done. Neo4j Community ${NEO4J_VERSION} installed at ${NEO4J_HOME}"
echo "==> Set an initial password before first start:"
echo "      sudo -u neo4j ${NEO4J_SYMLINK}/bin/neo4j-admin dbms set-initial-password <password>"
echo "==> If unset, the default password is 'neo4j' (you'll be prompted to change it at first login)."
