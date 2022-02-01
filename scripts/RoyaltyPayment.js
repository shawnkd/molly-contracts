module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
  
    const { deployer } = await getNamedAccounts()
  
    await deploy("RoyaltyPayment", {
      from: deployer,
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["RoyaltyPayment"]
  module.exports.dependencies = ["Token", "Marketplace"]