# Celestia Snapshot Service

Public snapshot infrastructure for Celestia node operators by Apollo Validator.

## Quick Start

### Download Latest Snapshot
curl -s https://apollo-validator.eu/api/celestia/snapshots/latest
wget https://apollo-validator.eu/celestia/snapshots/celestia-mainnet-HEIGHT.tar.lz4

### Restore from Snapshot
sudo systemctl stop celestia-appd
wget https://apollo-validator.eu/celestia/snapshots/celestia-mainnet-HEIGHT.tar.lz4
lz4 -d celestia-mainnet-HEIGHT.tar.lz4 | sudo tar -xf - -C /root/.celestia-app
sudo systemctl start celestia-appd

## API
GET /api/celestia/snapshots/latest

## Schedule
Snapshots are created every 6 hours automatically.

## Links
- Apollo Validator: https://apollo-validator.eu
- GitHub: https://github.com/Zelivsky

## License
MIT