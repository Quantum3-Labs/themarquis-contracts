#!/bin/bash

sozo migrate --rpc-url https://starknet-goerli.infura.io/v3/c45bd0ce3e584ba4a5e6a5928c9c0b0f

WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

# DO SOMETHING WITH THIS world address