### Initial Setup

```console
curl -L https://install.dojoengine.org | bash
```

Followed by:

```console
dojoup -v 0.4.4
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
cd /TheMarquis-contracts/l2/GAMEVAULT-Dojo && sozo build && sozo migrate
```

4. **Terminal 4 - Torii**:

Uncomment the 'world_address' parameter in `dojo-starter/Scarb.toml` then:

```console
cd /TheMarquis-contracts/l2/GAMEVAULT-Dojo && torii --world 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480
```

5. **initialize erc_20**

```bash
sozo execute 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108 initialize --calldata 123,123,0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480
```

6. **initialize actions**

```bash
sozo execute 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097 initialize --calldata 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108
```

7. **mint m_usd**

```bash
sozo execute 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108 mint_ --calldata 0x517ececd29116499f4a1b64b094da79ba08dfd54a3edaa316134c41f8160973,10000,0
```

8. **Spawn ok**

```bash
sozo execute 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097 spawn
```

```bash
sozo execute 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108 approve --calldata 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097,100,0
```

```bash
sozo execute 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097 move --calldata 1,2,20,30,2,2,3
Transaction: 0x40bf516fb3adca97ea71b6a5cbef14a88ef4b77bb208b15d25e1236712f08bb
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
