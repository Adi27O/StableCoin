//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract nUSD {
    string public name;
    string public symbol;
    uint8 public decimals;

    address private oracle;
    AggregatorV3Interface private priceFeed;

    mapping(address => uint256) private balances;
    uint256 public totalSupply;

    event Deposit(address indexed account, uint256 ethAmount, uint256 nUSDAmount);
    event Redeem(address indexed account, uint256 nUSDAmount, uint256 ethAmount);

    constructor(address _oracle) {
        name = "nUSD";
        symbol = "nUSD";
        decimals = 18;
        oracle = _oracle;
        priceFeed = AggregatorV3Interface(oracle);
    }

    // Function to deposit ETH and receive nUSD
    function deposit() public payable {
        uint256 ethValue = msg.value;
        uint256 nUSDValue = calculateNUSDValue(ethValue);

        balances[msg.sender] += nUSDValue;
        totalSupply += nUSDValue;

        emit Deposit(msg.sender, ethValue, nUSDValue);
    }

    // Function to redeem nUSD for ETH
    function redeem(uint256 nUSDAmount) public {
        require(balances[msg.sender] >= nUSDAmount, "Insufficient balance");

        uint256 ethAmount = calculateETHValue(nUSDAmount);
        require(address(this).balance >= ethAmount, "Insufficient ETH in the contract");

        balances[msg.sender] -= nUSDAmount;
        totalSupply -= nUSDAmount;

        (bool success, ) = msg.sender.call{value: ethAmount}("");
        require(success, "ETH transfer failed");

        emit Redeem(msg.sender, nUSDAmount, ethAmount);
    }

    // Function to get the current ETH price from the Chainlink oracle
    function getETHPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        return uint256(price);
    }

    // Internal function to calculate nUSD value based on ETH deposit
    function calculateNUSDValue(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getETHPrice();
        uint256 nUSDValue = (ethAmount * 10**decimals) / (ethPrice / 2);
        return nUSDValue;
    }

    // Internal function to calculate ETH value based on nUSD redemption
    function calculateETHValue(uint256 nUSDAmount) internal view returns (uint256) {
        uint256 ethPrice = getETHPrice();
        uint256 ethValue = (nUSDAmount * (ethPrice / 2)) / 10**decimals;
        return ethValue;
    }
}
