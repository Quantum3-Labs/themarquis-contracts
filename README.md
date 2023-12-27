<div align="center">
<img alt="starknet logo" src="https://github.com/Quantum3-Labs/TheMarquis-ui/blob/main/public/images/starknet-logo.png" width="200" >
  <h1 style="font-size: larger;">
    <img src="https://github.com/Quantum3-Labs/TheMarquis-ui/blob/main/public/images-game/100.png" width="30">
    <strong>The Marquis - Roulette</strong> 
    <img src="https://github.com/Quantum3-Labs/TheMarquis-ui/blob/main/public/images-game/100.png" width="30">
  </h1>

<a href="https://github.com/Quantum3-Labs/TheMarquis-contracts">
<img src="https://img.shields.io/badge/Overview-The%20Marquis%20Contracts-red"/>
</a>
<a href="">
<img src="https://img.shields.io/twitter/follow/TheMarquis?style=social"/>
</a>

</div>

### Single Deploy on Goerli
To execute all actions including the Dojo installation, run the following commands:

```bash
dojoup -v 0.4.2
cd TheMarquis-contracts/l2/GAMEVAULT-Dojo/scripts
bash build.sh
bash deploy.sh
bash setup.sh
bash mint.sh
bash bet.sh
bash winner.sh
```

### Individual Actions
To perform specific actions, execute the following commands:

- **Build Project:**
    ```bash
    bash build.sh
    ```
    This command compiles the project and generates the manifest file.

- **Deploy Project on Goerli:**
    ```bash
    bash deploy.sh
    ```
    Deploys the project on the Goerli network.

- **Initial Setup:**
    ```bash
    bash setup.sh
    ```
    Sets up contracts and necessary addresses for initializing the project and the game type.

- **Token Minting:**
    ```bash
    bash mint.sh
    ```
    Mint USD Marquis tokens for placing bets.

- **Placing Bets:**
    ```bash
    bash bet.sh
    ```
    Approves and places bets using USD Marquis.

- **Winner Selection:**
    ```bash
    bash winner.sh
    ```
    Selects the winner in the roulette game.

### Relevant Contracts on Goerli:

- [World Marquis](https://goerli.voyager.online/contract/0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3) - 0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3
- [Actions Marquis](https://goerli.voyager.online/contract/0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea) - 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea
- [Token USD Marquis](https://goerli.voyager.online/contract/0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e) - 0x0116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e

### Relevant Contracts on Sepolia:

- [World Marquis](https://sepolia.voyager.online/contract/0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3) - 0x7f9b2fd8cc27b20cb988be7fb7ae55459a6dddb0e1143ac1532b8b63e0463d3
- [Actions Marquis](https://sepolia.voyager.online/contract/0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea) - 0x21542c4f3ba51dbe3702e7d42064f73595196904ee32baa93cb871b2b1e11ea
- [Token USD Marquis](https://sepolia.voyager.online/contract/0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e) - 0x116d30283b84b826382d0115a985f71cdefd0dc7411c72dad1c0bbc9a292f5e

### Relevant Contracts on Sepolia V Dojo 4.2

- [World Marquis](https://sepolia.voyager.online/contract/0x2a36d89354970024eecaa6709a91b847a1810caeb5bca5d04a2ef009e201e80) - 0x2a36d89354970024eecaa6709a91b847a1810caeb5bca5d04a2ef009e201e80
- [Actions Marquis](https://sepolia.voyager.online/contract/0x365a607578bcb62edd3f950f4f9452b627027251a82ceff4611cb9ad4e93046) - 0x365a607578bcb62edd3f950f4f9452b627027251a82ceff4611cb9ad4e93046
- [Token USD Marquis](https://sepolia.voyager.online/contract/0x5029eebf9ecbda709b6d295faaa5c0962403c9b3f564bdedda906d21d19c928) - 0x5029eebf9ecbda709b6d295faaa5c0962403c9b3f564bdedda906d21d19c928