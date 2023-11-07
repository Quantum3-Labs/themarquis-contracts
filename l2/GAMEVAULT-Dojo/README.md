## Deploying on goerli

1. use your argent wallet address and private key
2. use the following command

```bash
sozo migrate --rpc-url https://starknet-goerli.g.alchemy.com/v2/DJQcaCKLJQ1gGtclqomTXYo6aRzeuKe5
```

3. transaction will fail, need to go to explorer and wait for the pending transactions to be confirmed
4. once confirmed, re-run the previous command until all models are registered ( you should see the invoke tx with register_model function)
5. delete models inside `manifest.json`, leave it as `"models": []`
6. re-run the previous command, if it fails wait for the transaction on explorer to be minted, then re-run the command again until the process finalizes successfully
