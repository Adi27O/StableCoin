const { ethers } = require('hardhat');

describe('nUSD', () => {
  let nUSD;
  let contractInstance;

  beforeEach(async () => {
    nUSD = await ethers.getContractFactory('nUSD');
    contractInstance = await nUSD.deploy('ORACLE_ADDRESS_GOES_HERE');
    await contractInstance.deployed();
  });

  it('should deposit ETH and receive nUSD', async () => {
    const [deployer] = await ethers.getSigners();

    const ethAmount = ethers.utils.parseEther('1');
    const nUSDValue = await contractInstance.calculateNUSDValue(ethAmount);

    await contractInstance.deposit({ value: ethAmount });

    const balance = await contractInstance.balances(deployer.address);
    const totalSupply = await contractInstance.totalSupply();

    assert.equal(balance.toString(), nUSDValue.toString(), 'Incorrect nUSD balance');
    assert.equal(totalSupply.toString(), nUSDValue.toString(), 'Incorrect total supply');
  });

  it('should redeem nUSD and receive ETH', async () => {
    const [deployer] = await ethers.getSigners();

    const balanceBefore = await deployer.getBalance();

    const nUSDAmount = await contractInstance.balances(deployer.address);
    const ethValue = await contractInstance.calculateETHValue(nUSDAmount);

    await contractInstance.redeem(nUSDAmount);

    const balanceAfter = await deployer.getBalance();
    const balanceDifference = balanceAfter.sub(balanceBefore);

    assert.equal(balanceDifference.toString(), ethValue.toString(), 'Incorrect ETH amount received');
  });
});
