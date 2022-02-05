module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments

  const { deployer, tokenOwner } = await getNamedAccounts()

  await deploy("Highlight", {
    from: tokenOwner,
    args: ["name", 5, 5, tokenOwner, "12345"],
    log: true,
    deterministicDeployment: false
  })
}

module.exports.tags = ["Highlight"]
