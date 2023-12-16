#!/bin/bash
source .env

WORLD_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.world.address')
THE_MARQUIS_ACTIONS_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "actions" ).address')
USD_M_TOKEN_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.contracts[] | select(.name == "erc_systems" ).address')

echo -e '\n✨ Performing setup for the following : ✨'
echo -e "WORLD_ADDRESS: $WORLD_ADDRESS"
echo -e "THE_MARQUIS_ACTIONS_ADDRESS: $THE_MARQUIS_ACTIONS_ADDRESS"
echo -e "USD_M_TOKEN_ADDRESS: $USD_M_TOKEN_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis.json
export STARKNET_KEYSTORE=../account/Signer_Marquis.json
export STARKNET_RPC=$DOJO_GOERLI_RPC_URL

# INITIALIZE
echo -e '\n✨ Initializing contracts✨'

starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS initialize $USD_M_TOKEN_ADDRESS --keystore-password $PASSWORD --watch

starkli invoke $USD_M_TOKEN_ADDRESS initialize 0x557364204d617271756973 0x5573644d $WORLD_ADDRESS --keystore-password $PASSWORD --watch

echo -e '\n✨ Spawn first game✨'
starkli invoke $THE_MARQUIS_ACTIONS_ADDRESS spawn --keystore-password $PASSWORD --watch


# starkli invoke 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e mint_ 0x031be432d79a570ccf17288e5aca2ac3884c4dc0558df1f455a7df3aa820147f 1000000000000000000000 0 --keystore-password $PASSWORD
# sleep 10

# ## MINT
# echo -e '\n✨ Approve and Bet ✨'
# starkli invoke 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e approve 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea 100000000000000000000 0 --keystore-password $PASSWORD
# sleep 10
# starkli invoke 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea move 1 2 20 30 2 2 3 --keystore-password $PASSWORD

echo -e '\n✨ Setup completed ✨'