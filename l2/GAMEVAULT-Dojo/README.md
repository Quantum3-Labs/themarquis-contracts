### Initial Setup

```console
curl -L https://install.dojoengine.org | bash
```

Followed by:

```console
dojoup -v 0.5.1
```

For an in-depth setup guide, consult the [Dojo book](https://book.dojoengine.org/getting-started/quick-start.html).

### Launch the Example in Under 30 Seconds

After cloning the project, execute the following:

1. **Terminal 1 - Katana**:

```console
katana --disable-fee
```

2. **Terminal 2 - Contracts**:

```console
cd l2/GAMEVAULT-Dojo && sozo build && sozo migrate
```

4. **Terminal 4 - Torii**:

In `dojo-starter/Scarb.toml` then:

```console
cd l2/GAMEVAULT-Dojo && torii --world 0x262f386d92db8016458f779c46f5f56b837734e111bde17e5836890d5acfe25
```

5. **initialize erc_20**

```bash
sozo execute 0x6339055f1c6d0e3c09ae7b4edcc3b0baa300e08203b7f99f93da819a59ed085 initialize --calldata 123,123,0x262f386d92db8016458f779c46f5f56b837734e111bde17e5836890d5acfe25
```

6. **initialize actions**

````bash
sozo execute 0x306aee16fcbec0d4490a348fd15f3150c63992533230f6b7d638bb2b9cf5e3c initialize --calldata 0x6339055f1c6d0e3c09ae7b4edcc3b0baa300e08203b7f99f93da819a59ed085
```

7. **mint m_usd**

```bash
sozo execute 0x6339055f1c6d0e3c09ae7b4edcc3b0baa300e08203b7f99f93da819a59ed085 mint_ --calldata 0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,10000,0
````

8. **Spawn ok**

```bash
sozo execute 0x306aee16fcbec0d4490a348fd15f3150c63992533230f6b7d638bb2b9cf5e3c spawn
```

```bash
sozo execute 0x6339055f1c6d0e3c09ae7b4edcc3b0baa300e08203b7f99f93da819a59ed085 approve --calldata 0x306aee16fcbec0d4490a348fd15f3150c63992533230f6b7d638bb2b9cf5e3c,100,0
```

```bash
sozo execute 0x306aee16fcbec0d4490a348fd15f3150c63992533230f6b7d638bb2b9cf5e3c move --calldata 1,2,20,30,2,2,3
```

Optional 9. **Auth**

```bash
bash ./scripts/default_auth.sh
```

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

## Deployed contracts [Goerli]

the_marquis_actions : 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097

world : 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480

dojo_erc20 : 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108
