#!/bin/bash
set -euo pipefail
DATA_DIR=/root/.celestia-app
SNAP_DIR=/var/www/snapshots/celestia/snapshots
META_DIR=/var/www/snapshots/celestia
CELESTIA_RPC=localhost:36657
KEEP_LAST=2
HEIGHT=$(curl -s --max-time 5 http://$CELESTIA_RPC/status | jq -r '.result.sync_info.latest_block_height')
if [ -z "$HEIGHT" ] || [ "$HEIGHT" = "null" ]; then echo "ERROR: Cannot get block height"; exit 1; fi
SNAP_FILE="celestia-mainnet-${HEIGHT}.tar.lz4"
SNAP_PATH="$SNAP_DIR/$SNAP_FILE"
CHECKSUM_FILE="$SNAP_PATH.sha256"
if [ -f "$SNAP_PATH" ]; then echo "Snapshot for height $HEIGHT already exists, skipping"; exit 0; fi
echo "Creating snapshot at height $HEIGHT..."
sudo tar -C "$DATA_DIR" -cf - data/ | lz4 -9 > "$SNAP_PATH"
sha256sum "$SNAP_PATH" > "$CHECKSUM_FILE"
SIZE=$(du -h "$SNAP_PATH" | cut -f1)
CHECKSUM=$(awk '{print $1}' "$CHECKSUM_FILE")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
cat > "$META_DIR/latest.json" << EOF
{"height":$HEIGHT,"size":"$SIZE","created":"$TIMESTAMP","file":"$SNAP_FILE","checksum":"sha256:$CHECKSUM","network":"celestia-mainnet"}
EOF
cd "$SNAP_DIR"
ls -t celestia-mainnet-*.tar.lz4 2>/dev/null | tail -n +$((KEEP_LAST + 1)) | xargs -r rm -f
ls -t celestia-mainnet-*.sha256 2>/dev/null | tail -n +$((KEEP_LAST + 1)) | xargs -r rm -f
echo "Snapshot created: $SNAP_FILE ($SIZE)"