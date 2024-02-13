This the repo used on Istambul HH

Make sure to downgrade your dojo version to v0.3.10

```bash
dojoup -v 0.3.10
```

## Deploying on goerli (Todo)

1. use your argent wallet address and private key
2. use the following command

```bash
sozo migrate --rpc-url https://starknet-goerli.g.alchemy.com/v2/DJQcaCKLJQ1gGtclqomTXYo6aRzeuKe5
```

3. transaction will fail, need to go to explorer and wait for the pending transactions to be confirmed
4. once confirmed, re-run the previous command until all models are registered ( you should see the invoke tx with register_model function)
5. delete models inside `manifest.json`, leave it as `"models": []`
6. re-run the previous command, if it fails wait for the transaction on explorer to be minted, then re-run the command again until the process finalizes successfully

## Deployed contracts [Goerli]

the_marquis_actions : 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097

world : 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480

dojo_erc20 : 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108
