# 🐖 PiggyBank Smart Contract

A decentralized Piggy Bank smart contract that allows users to deposit ETH and withdraw it after a specified deadline. This project includes scripts for deploying, funding, and withdrawing, and is built with **Solidity**, **Foundry**, and **Forge scripts** for automation.

---

## 📄 Table of Contents

* [About](#about)
* [Features](#features)
* [Getting Started](#getting-started)
* [Deployment](#deployment)
* [Scripts](#scripts)
* [Testing](#testing)
* [License](#license)

---

## 🧐 About

PiggyBank is a simple Ethereum smart contract that simulates a traditional piggy bank in a decentralized environment. Users can:

* Deposit ETH into the PiggyBank.
* Withdraw ETH only after a certain deadline.
* Track individual contributions.



---

## ✨ Features

* Deposit ETH via a payable function.
* Withdraw ETH safely, respecting the unlock time.
* Keep track of individual contributions.
* Fully testable using **Foundry** scripts.
* Deployment and interaction scripts automate deposits and withdrawals.

---

## 🛠 Getting Started

### Requirements

* [Foundry](https://github.com/foundry-rs/foundry) installed
* Node.js (optional if using Hardhat or frontend)
* An Ethereum wallet (for testnets or mainnet)

---

### Install Dependencies

```bash
forge install
```

---

## 🚀 Deployment

You can deploy the PiggyBank contract locally or to a testnet like Sepolia.

```bash
forge script script/DeployPiggyBank.s.sol:DeployPiggyBank \
--rpc-url $SEPOLIA_RPC \
--private-key $WALLET_KEY \
--broadcast
```

---

## 📜 Scripts

### Deposit Script

Allows a user to deposit ETH into the PiggyBank.

```bash
forge script script/DepositInPiggyBank.s.sol:DepositInPiggyBank \
--rpc-url $SEPOLIA_RPC \
--private-key $WALLET_KEY \
--broadcast \
--value 0.01ether
```

* The deposit will be recorded under the **caller’s address**.
* Supports testing with Foundry `vm.prank` for local simulations.

---

### Withdraw Script

Allows a user to withdraw ETH from the PiggyBank.

```bash
forge script script/WithdrawFromPiggyBank.s.sol:WithdrawFromPiggyBank \
--rpc-url $SEPOLIA_RPC \
--private-key $WALLET_KEY \
--broadcast
```

* Only the original depositor can withdraw.
* Respects unlock time if implemented.

---

## 🧪 Testing

Run all tests using Foundry:

```bash
forge test
```

Example test scenario:

* Deposit 0.01 ETH from a user
* Check the deposited amount is recorded correctly
* Withdraw and confirm the balance is updated

---

## 📌 Notes

* Make sure your deposit script is **payable** to forward ETH from the user.
* Use `vm.startBroadcast()` in scripts when deploying or interacting with contracts to ensure the **caller is the intended signer**.

---

## 📝 License

This project is MIT licensed.

