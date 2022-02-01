import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { Marketplace } from "../typechain";


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
      this.Token = await ethers.getContractFactory("Token");
      this.token = await this.Token.deploy(this.alice.address);
      const deployedToken = await this.token.deployed();
      const NFT = await deployedToken.mint(this.alice.address, hash)
      console.log(NFT.address)
      console.log(await deployedToken.tokensOfOwner(this.alice.address))

      //console.log(await deployedToken.getApproved(1))
      this.Marketplace = await ethers.getContractFactory("Marketplace");
      this.marketplace = await this.Marketplace.deploy(deployedToken.address)
      this.royaltiesPayment = await ethers.getContractFactory("RoyaltiesPayment") 
      this.sellOffer = expect( await this.marketplace.makeSellOffer(1, 1)).to.emit(this.marketplace, 'NewSellOffer')     
    })

    it("should create buy offer", async function () {
    
      const hash = '123452'
      this.Token = await ethers.getContractFactory("Token");
      this.token = await this.Token.deploy(this.alice.address);
      const deployedToken = await this.token.deployed();
      const NFT = await deployedToken.mint(this.alice.address, hash)
      console.log(NFT.address)
      console.log(await deployedToken.tokensOfOwner(this.alice.address))

      //console.log(await deployedToken.getApproved(1))
      this.Marketplace = await ethers.getContractFactory("Marketplace");
      this.marketplace = await this.Marketplace.deploy(deployedToken.address)
      this.royaltiesPayment = await ethers.getContractFactory("RoyaltiesPayment") 
      this.sellOffer = expect( await this.marketplace.makeSellOffer(1, 1)).to.emit(this.marketplace, 'NewSellOffer') 
      
      const buyOffer = expect(await this.marketplace.connect(this.bob).makeBuyOffer(1))
    })
  
  });

  
