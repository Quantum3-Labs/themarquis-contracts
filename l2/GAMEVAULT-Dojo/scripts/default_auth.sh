#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="https://starknet-sepolia.public.blastapi.io/rpc/v0_6";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "actions" ).address')

echo "---------------------------------------------------------------------------"
echo world : 0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3
echo erc_systems: 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e
echo actions : 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("Position" "Moves" )

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL --account-address $DEPLOYER_ADDRESS --private-key $DEPLOYER_PK
done

echo "Default authorizations have been successfully set."