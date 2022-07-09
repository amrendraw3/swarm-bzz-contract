const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BzzBondingCurve", function () {
  it("Should return the new greeting once it's changed", async function () {
    const BzzBondingCurve = await ethers.getContractFactory("BzzBondingCurve");
    const curve = await BzzBondingCurve.deploy();
    await curve.deployed();


    const price = await curve.buyPrice("10000000000000000", "10000000000000000");
    console.log(price);
    const sell = await curve.sellReward("10000000000000000", "1000000000000000000");
    console.log(sell);
  });
});
