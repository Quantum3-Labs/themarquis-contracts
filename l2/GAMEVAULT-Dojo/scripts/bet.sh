#!/bin/bash
source .env

THE_MARQUIS_ACTIONS_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v3_0::the_marquis::actions::actions" ).address')
USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "l2_v3_0::erc20_dojo::erc20::erc_systems" ).address')

echo -e "THE_MARQUIS_ACTIONS_ADDRESS: $THE_MARQUIS_ACTIONS_ADDRESS"
echo -e "USD_M_TOKEN_ADDRESS: $USD_M_TOKEN_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis_Sepolia.json
export STARKNET_KEYSTORE=../account/Signer_Marquis_Sepolia.json
export STARKNET_RPC=$DOJO_SEPOLIA_RPC_URL

# ## APPROVE AND BET
echo -e '\n✨ Approve and Bet ✨'
starkli invoke $USD_M_TOKEN_ADDRESS approve $THE_MARQUIS_ACTIONS_ADDRESS 1000000000000000000000 0 --keystore-password $PASSWORD --watch

starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS move 0 2 16 17 2 10000000 50000000 --keystore-password $PASSWORD  --watch
