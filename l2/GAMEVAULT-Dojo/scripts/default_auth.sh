#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v4_0::the_marquis::actions::actions" ).address')

echo "---------------------------------------------------------------------------"
echo world : 0x5fdfd7cfccb3af0e8ac3c0490dfb6034465debd839369fdc3a2d9dadc4f056
echo erc_systems: 0x1a2d94c3e453d9491121487e13414b105790f6f16e4da38bbe16d2163d7dcfd
echo actions : 0x4d8676f82bef652080f09e6734f2018c8fd024493fc134424dcaf7ebf0be0e
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("Game" "Move" "WorldHelperStorage")

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL 
done

echo "Default authorizations have been successfully set."