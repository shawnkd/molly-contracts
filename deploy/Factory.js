module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments

  const { deployer, tokenOwner } = await getNamedAccounts()

  await deploy("Factory", {
    from: deployer,
    log: true,
    deterministicDeployment: false
  })
}

module.exports.tags = ["Factory"]