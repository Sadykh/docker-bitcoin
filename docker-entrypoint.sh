#!/bin/bash
set -e

mkdir -p "$BITCOIN_DATA"

if [[ ! -s "$BITCOIN_DATA/bitcoin.conf" ]]; then
    cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
		printtoconsole=1
		rpcallowip=::/0
    testnet=${TESTNET:-0}
    txindex=1
    rpcuser=${RPCUSER:-btcuser}
    rpcpassword=${RPCPASSWORD:-saintpetersburg}
    rpcport=${RPCPORT:-8332}
    onlynet=ipv4
		EOF
		chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"
fi

# ensure correct ownership and linking of data directory
# we do not update group ownership here, in case users want to mount
# a host directory and still retain access to it
chown -R bitcoin "$BITCOIN_DATA"
ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

if [ $# -eq 0 ]; then
  exec gosu bitcoin bitcoind "$@"
else
  exec "$@"
fi
