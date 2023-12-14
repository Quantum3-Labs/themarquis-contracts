#!/bin/bash

sozo migrate --rpc-url $DOJO_GOERLI_RPC_URL

WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

# DO SOMETHING WITH THIS world address