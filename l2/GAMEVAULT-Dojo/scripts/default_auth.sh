#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "actions" ).address')

export ERC_SYSTEMS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "erc_systems" ).address')

echo "---------------------------------------------------------------------------"
echo world : 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480
echo erc_systems: 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108
echo actions : 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS_ERC_SYSTEMS=("ERC20Allowance" "ERC20Meta" "ERC20Balance")
COMPONENTS_ACTIONS=("Game" "Move" "WorldHelperStorage")

for component in ${COMPONENTS_ACTIONS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
done

for component in ${COMPONENTS_ERC_SYSTEMS[@]}; do
    sozo auth writer $component $ERC_SYSTEMS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
done

echo "Default authorizations have been successfully set."