#!/bin/bash
source .env

sozo migrate --rpc-url $DOJO_GOERLI_RPC_URL --account-address $DEPLOYER_ADDRESS --private-key $DEPLOYER_PK

WORLD_ADDRESS=$(cat ../target/dev/manifest.json.bak | jq -r '.world.address')
THE_MARQUIS_ACTIONS_ADDRESS=$(cat ../target/dev/manifest.json.bak | jq -r '.contracts[] | select(.name == "actions" ).address')
USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json.bak | jq -r '.erc_systems.address')

# DO SOMETHING WITH THIS world address

## INITIALIZE

export STARKNET_ACCOUNT=../account/Account_Marquis.json
export STARKNET_KEYSTORE=../account/Signer_Marquis.json
export STARKNET_RPC="https://starknet-testnet.public.blastapi.io"

echo -e '\n✨ Start Initialize The Marquis ✨'

# Utilizando comillas para manejar valores de las variables
starkli invoke 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea initialize 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD

sleep 10

starkli invoke 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e initialize 0x557364204d617271756973 0x5573644d 0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3 --keystore-password $PASSWORD

sleep 3

## MINT

echo -e '\n✨ Start 100 Mint Usd Marquis ✨'

starkli invoke 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea spawn --keystore-password $PASSWORD

sleep 3

starkli invoke 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e mint_ 0x031be432d79a570ccf17288e5aca2ac3884c4dc0558df1f455a7df3aa820147f 1000000000000000000000 0 --keystore-password $PASSWORD

sleep 3

## MINT

echo -e '\n✨ Approve and Bet ✨'

starkli invoke 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e approve 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea 100000000000000000000 0 --keystore-password $PASSWORD

sleep 3

starkli invoke 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea move 1 2 20 30 2 2 3 --keystore-password $PASSWORD
