#!/bin/bash
source .env

THE_MARQUIS_ACTIONS_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "actions" ).address')

echo -e "THE_MARQUIS_ACTIONS_ADDRESS: $THE_MARQUIS_ACTIONS_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis_Sepolia.json
export STARKNET_KEYSTORE=../account/Signer_Marquis_Sepolia.json
export STARKNET_RPC=$DOJO_SEPOLIA_RPC_URL

# ## WINNER

echo -e '\n✨ Winner the Roulette ✨'

starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS set_winner 0 15 --keystore-password $PASSWORD --watch

