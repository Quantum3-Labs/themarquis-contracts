### Initial Setup

The repository already contains the `dojo-starter` as a submodule. Feel free to remove it if you prefer.

**Prerequisites:** First and foremost, ensure that Dojo is installed on your system. If it isn't, you can easily get it set up with:

```console
curl -L https://install.dojoengine.org | bash
```

Followed by:

```console
dojoup    
```

For an in-depth setup guide, consult the [Dojo book](https://book.dojoengine.org/getting-started/quick-start.html).

### Launch the Example in Under 30 Seconds

After cloning the project, execute the following:

1. **Terminal 1 - Katana**:

```console
cd dojo-starter && katana --disable-fee
```

2. **Terminal 2 - Contracts**:

```console
cd dojo-starter && sozo build && sozo migrate
```

3. **Terminal 3 - Client**:

```console
cd client && yarn && yarn dev
```

or if using bun

```console
cd client && bun install && bun dev
```

4. **Terminal 4 - Torii**:

Uncomment the 'world_address' parameter in `dojo-starter/Scarb.toml` then:

```console
cd dojo-starter && torii --world 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480
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
sozo execute 0x59bbd83d1178b7d10f7ffec372d4593283e9b5aa6075349834162deecfe5108 mint_ --calldata 0x6e31e6291f572cf76e11f1c99af8284f0d160f9f3af74e7e787a0f598bf0480,100,0
```

8. **Spawn ok**

```bash
sozo execute 0x6ba9e3effb660a56ae35dc1b8304be20c8bbf262997dc82d4c9052add1da097 spawn
```

9. **Auth**

```bash
bash ./scripts/default_auth.sh
```