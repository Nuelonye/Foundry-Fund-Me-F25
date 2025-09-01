# Foundry Fund Me

A decentralized crowdfunding smart contract built with Solidity and Foundry.
Individuals can fund a contract and the owner can withdraw funds securely.

## 🚀 Features

fund: Allow users to send ETH to the contract.

withdraw: Allow only the contract owner to withdraw funds.

onlyOwner modifier: Access control with custom errors.

Deployment and interaction scripts using Foundry’s Script system.

Unit tests with high coverage, testing:

funding,

withdrawing,

ownership restrictions


## Quickstart

```shell
git clone https://github.com/Nuelonye/Foundry-Fund-Me
cd foundry-fund-me
forge build
```

## 🧪 Testing

Run the full suite:
```shell
forge test -vvv
```

Check test coverage:
```shell
forge coverage
```

## 📜 Scripts

This repo uses Foundry’s Script system for deployments and interactions.

Deploy FundMe:
```shell
forge script script/DeployFundMe.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```
NOTE: when deploying on anvil comment out ETHERSCAN_API_KEY from .env if you have any


Fund Contract:
```shell
forge script script/FundMeInteractions.s.sol:FundFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Withdraw From Contract:
```shell
forge script script/FundMeInteractions.s.sol:WithdrawFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Deploy And Verify On Sepolia Etherscan
```shell
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account <account name> --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
```
OR  --private-key $SEPOLIA_PRIVATE_KEY IF IT'S NOT encrypted

## 🌍 Networks

You can deploy to any EVM-compatible network.

Update your .env file with:
```shell
RPC_URL=https://your-network-rpc
PRIVATE_KEY=your-private-key
ETHERSCAN_API_KEY=your-etherscan-key
```

## License
MIT

## 📚 Resources
Teacher - Patrick Collins

Cyfrin Updraft