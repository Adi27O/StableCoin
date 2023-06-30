# StableCoin
# nUSD Stablecoin

This project implements the nUSD stablecoin smart contract, which is backed by ETH and allows users to deposit ETH and receive nUSD tokens. It also provides a redeem function to convert nUSD back into ETH at the current exchange rate. The contract integrates with a Chainlink oracle to fetch real-time price data for ETH to calculate the appropriate exchange rates.

## Overview

The nUSD contract is implemented in Solidity and follows the ERC20 token standard. It provides the following functionalities:

- Deposit ETH and receive nUSD tokens at a rate of 50% of the deposited ETH value.
- Redeem nUSD tokens and receive ETH at the current exchange rate, which requires double the value of nUSD tokens being redeemed.
- Maintain the total supply of nUSD tokens based on the deposit and redemption actions.

## Assumptions

- The implementation assumes a fixed exchange rate of 1 ETH = 2 nUSD for simplicity. In a real-world scenario, a more dynamic and adjustable mechanism for maintaining the stablecoin value would be implemented.
- The project assumes the usage of a testnet Chainlink oracle for obtaining real-time ETH price data. The address of the Chainlink oracle contract should be provided during contract deployment.

## Notes

- Before deploying the contract, ensure that you have the correct address of the Chainlink oracle contract for the testnet you're using and replace the placeholder in the constructor.
- Thoroughly test the contract on a testnet before deploying it to a production environment.
- The project includes a unit test file (`nUSD.test.js`) to verify the functionalities of the smart contract using the Hardhat testing framework. Run `npx hardhat test` to execute the tests.
- Make sure to review and understand the code and modify it as per your specific requirements and security considerations.

