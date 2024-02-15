#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";
export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')
export ACTIONS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v4_2::the_marquis::actions::actions" ).address')
export ERC_SYSTEMS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v4_2::erc20_dojo::erc20::erc_systems" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS
echo erc_systems: $ERC_SYSTEMS_ADDRESS
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS_ERC_SYSTEMS=("ERC20Allowance" "ERC20Meta" "ERC20Balance")
COMPONENTS=("Game" "Move" "WorldHelperStorage")

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 2 
done

for component in ${COMPONENTS_ERC_SYSTEMS[@]}; do
    sozo auth writer $component $ERC_SYSTEMS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 2
done

echo "Default authorizations have been successfully set."