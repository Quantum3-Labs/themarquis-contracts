#!/bin/bash

sozo migrate --rpc-url $DOJO_GOERLI_RPC_URL

WORLD_ADDRESS=$(cat ../target/dev/manifest.json.bak | jq -r '.world.address')

# DO SOMETHING WITH THIS world address

## INITIALIZE

echo -e '\n✨ Start Initialize The Marquis ✨'

starkli invoke 0x7f586bb3fbc52365a9abc8fdddd0b8e20d52095574e2413fae1a76ae6c7641 initialize 0x2725bce13b1e2d5f54c0bd5c3cd8ba62917e8db648e2467ad4b17003912594d   
sleep 10
starkli invoke 0x2725bce13b1e2d5f54c0bd5c3cd8ba62917e8db648e2467ad4b17003912594d initialize 0x557364204d617271756973 0x5573644d 0x25d273fd35821bb6b0fd72dbb83c79c071c05706ec08b3c73c4b3b014d49529

## MINT

echo -e '\n✨ Start Mint Usd Marquis ✨'

starkli invoke 0x7f586bb3fbc52365a9abc8fdddd0b8e20d52095574e2413fae1a76ae6c7641 spawn
starkli invoke 0x2725bce13b1e2d5f54c0bd5c3cd8ba62917e8db648e2467ad4b17003912594d mint_ 0x027f68d0d0f474b1a25f359a42dc49a3003a3522d71765a5e7658e68520d7826 10000 0

