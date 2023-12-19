#!/bin/bash
source .env

USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "erc_systems" ).address')

echo -e "USD_M_TOKEN_ADDRESS: $USD_M_TOKEN_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis.json
export STARKNET_KEYSTORE=../account/Signer_Marquis.json
export STARKNET_RPC=$DOJO_GOERLI_RPC_URL

# ## MINT
echo -e '\n✨ Mint USD Marquis ✨'
starkli invoke $USD_M_TOKEN_ADDRESS mint_ 0x031be432d79a570ccf17288e5aca2ac3884c4dc0558df1f455a7df3aa820147f 1000000000000000000000 0 --keystore-password $PASSWORD --watch
