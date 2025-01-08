# BFT - ERC20 Token with Stakeholder Distribution

## Overview

**BFT** is an ERC20 token contract designed to allocate the initial supply to predefined stakeholders such as the team, marketing, development, and community. The token includes functionality for secure token distribution, wallet updates, and token recovery.

---

## Features

- **Initial Supply Distribution**: Allocates the total supply to predefined stakeholder wallets.
- **Stakeholder Percentages**:
  - Team: 20%
  - Marketing: 30%
  - Development: 40%
  - Community: 10%
- **Secure Wallet Updates**: Allows the owner to update wallet addresses.
- **Token Recovery**: Enables the owner to recover tokens accidentally sent to the contract, excluding the contract's tokens.
- **Gas Efficient**: Optimized for efficiency with non-reentrant distribution logic.

---

## Contract Details

- **Name**: BFT
- **Symbol**: BFT
- **Initial Supply**: 1,000,000 BFT (1 million tokens)

---

## Requirements

### Development Environment

- **Solidity**: ^0.8.24
- **Foundry**: Installed and configured for testing and deployment.
- **OpenZeppelin Contracts**: Included for ERC20 and ownership functionalities.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jitendragangwar123/BFT.git
   cd BFT
   ```
2. Install dependencies:
   ```bash
   make install
   ```

### 🚀 Deploy
This will default to your local node. You need to have it running in another terminal in order for the deployment to work.
```
$ make deploy
```

### 🧪 Testing

You can run tests in various environments:

1. **Unit Tests**
2. **Integration Tests**
3. **Forked Network Tests**
4. **Staging Tests**

To run all tests, use:

```
$ forge test
```
or

```
$ forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
$ forge coverage
```

### 🌍 Deployment to a Testnet or Mainnet

   #### 1. Setup Environment Variables

   You'll need to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file in your project directory.

   Optionally, you can also add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

   #### 2. Get Testnet ETH

   Head over to [faucets.chain.link](https://faucets.chain.link/) to get some testnet ETH. The ETH should show up in your MetaMask wallet shortly.

   #### 3. Deploy to Sepolia Testnet

   To deploy your contract to the **Sepolia** testnet, run:

   ```
   $ make deploy ARGS="--network sepolia"
   ```

