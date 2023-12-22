#!/bin/bash
source .env

WORLD_ADDRESS=$(cat ../target/dev/manifest.json | jq -r '.world.address')

echo -e "WORLD_ADDRESS: $WORLD_ADDRESS"

# VARIABLES
export STARKNET_ACCOUNT=../account/Account_Marquis_Sepolia.json
export STARKNET_KEYSTORE=../account/Signer_Marquis_Sepolia.json
export STARKNET_RPC=$DOJO_SEPOLIA_RPC_URL

# ## Initialize NEW ACCOUNT
echo -e '\n✨ Initialize Position ✨'
starkli invoke $WORLD_ADDRESS grant_writer 0x506f736974696f6e 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD --watch

echo -e '\n✨ Initialize Moves ✨'
starkli invoke $WORLD_ADDRESS grant_writer 0x4d6f766573 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD --watch

echo -e '\n✨ Initialize ERC20Allowance ✨'
starkli invoke $WORLD_ADDRESS grant_writer 0x455243323042616c616e6365 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD --watch

echo -e '\n✨ Initialize ERC20Meta ✨'
starkli invoke $WORLD_ADDRESS grant_writer 0x45524332304d657461 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD --watch

echo -e '\n✨ Initialize ERC20Meta ✨'
starkli invoke $WORLD_ADDRESS grant_writer 0x45524332304d657461 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e --keystore-password $PASSWORD --watch
