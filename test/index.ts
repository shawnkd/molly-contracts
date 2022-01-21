import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "ethers";


describe("Test", function () {

  before(async function () {
    this.signers = await ethers.getSigners()
    this.alice = this.signers[0]
    this.bob = this.signers[1]
    this.carol = this.signers[2]
  })


    it("Should mint a token", async function () {
      const hash = '123452'
      const hash1 = '123232'
      const Token = await ethers.getContractFactory("Token");
      const token = await Token.deploy(this.alice.address);
      const deployedToken = await token.deployed();
      const NFT = await deployedToken.mint(this.alice.address, hash)
      const NFT2 = await deployedToken.mint(this.alice.address, hash1)
      const name = await deployedToken.name()
      const symbol = await deployedToken.symbol()
      console.log(name)
      console.log(symbol)
      console.log(NFT.hash)
      console.log(await deployedToken.tokensOfOwner(this.alice.address))

    });

    it("should create a marketplace", async function () {
      const Token = await ethers.getContractFactory("Token");
      const token = await Token.deploy(this.alice.address);
      const deployedToken = await token.deployed();
      const Marketplace = await ethers.getContractFactory("Token");
      await Marketplace.deploy(deployedToken.address)
    })

    it("should create sale offer", async function () {
      const hash = '123452'
      const Token = await ethers.getContractFactory("Token");
      const token = await Token.deploy(this.alice.address);
      const deployedToken = await token.deployed();
      const NFT = await deployedToken.mint(this.alice.address, hash)
      const Marketplace = await ethers.getContractFactory("Marketplace");
      const marketplace = await Marketplace.deploy(deployedToken.address)
      console.log(await marketplace.makeSellOffer(1, 1))

    })

  });

  
