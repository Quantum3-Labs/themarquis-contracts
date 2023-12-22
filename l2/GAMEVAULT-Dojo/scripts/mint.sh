#!/bin/bash
source .env

USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "erc_systems" ).address')

echo -e "USD_M_TOKEN_ADDRESS: $USD_M_TOKEN_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis_Sepolia.json
export STARKNET_KEYSTORE=../account/Signer_Marquis_Sepolia.json
export STARKNET_RPC=$DOJO_SEPOLIA_RPC_URL

# ## MINT
echo -e '\n✨ Mint USD Marquis ✨'
starkli invoke $USD_M_TOKEN_ADDRESS mint_ 0x07afdaf5d788e65005e83878c8adc48479daf119e02c96bc4360e16a97764ea6 1000000000000000000000 0 --keystore-password $PASSWORD --watch
