module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
  
    const { deployer } = await getNamedAccounts()
  
    await deploy("Marketplace", {
      from: deployer,
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["Marketplace"]
  module.exports.dependencies = ["Token"]
  