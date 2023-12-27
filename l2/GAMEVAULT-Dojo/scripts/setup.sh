#!/bin/bash
source .env

WORLD_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.world.address')
THE_MARQUIS_ACTIONS_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v3_0::the_marquis::actions::actions" ).address')
USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v3_0::erc20_dojo::erc20::erc_systems" ).address')

echo -e '\n✨ Performing setup for the following : ✨'
echo -e "WORLD_ADDRESS: $WORLD_ADDRESS"
echo -e "THE_MARQUIS_ACTIONS_ADDRESS: $THE_MARQUIS_ACTIONS_ADDRESS"
echo -e "USD_M_TOKEN_ADDRESS: $USD_M_TOKEN_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis_Sepolia.json
export STARKNET_KEYSTORE=../account/Signer_Marquis_Sepolia.json
export STARKNET_RPC=$DOJO_SEPOLIA_RPC_URL

# INITIALIZE
echo -e '\n✨ Initializing contracts✨'

starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS initialize $USD_M_TOKEN_ADDRESS --keystore-password $PASSWORD --watch

starkli invoke $USD_M_TOKEN_ADDRESS initialize 0x557364204d617271756973 0x5573644d $WORLD_ADDRESS --keystore-password $PASSWORD --watch

echo -e '\n✨ Spawn first game✨'
starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS spawn --keystore-password $PASSWORD --watch

echo -e '\n✨ Setup completed ✨'

