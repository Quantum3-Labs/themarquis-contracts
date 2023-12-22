#!/bin/bash
source .env

sozo migrate --rpc-url $DOJO_SEPOLIA_RPC_URL --account-address $DEPLOYER_ADDRESS --private-key $DEPLOYER_PK