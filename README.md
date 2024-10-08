# Population DApp

This is a decentralized application (DApp) built with Flutter and Ethereum, where users can interact with a smart contract to view and update population data for a specific country.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Smart Contract](#smart-contract)
- [Usage](#usage)
- [License](#license)

## Overview

The **Population DApp** allows users to:
- View the current population and country name stored in the Ethereum blockchain.
- Update the country name and population using transactions.
- Increment or decrement the population value.

This DApp interacts with a smart contract deployed on the Ethereum blockchain using Web3dart and WalletConnect to connect with MetaMask or other Ethereum wallets.

## Features

- **Blockchain Interaction**: Interacts with a smart contract deployed on Ethereum.
- **WalletConnect**: Allows users to connect their MetaMask wallet for transactions.
- **Real-Time Updates**: Fetch and display data from the Ethereum blockchain in real-time.
- **Population Management**: Users can increment, decrement, or set the population data on the blockchain.

## Prerequisites

Before running the DApp, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [MetaMask Wallet](https://metamask.io/) (Mobile or Browser Extension)
- Node.js and NPM for running a local blockchain (optional)
- Ganache or Infura (if using a test network)

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/yourusername/population_dapp.git
   cd population_dapp
