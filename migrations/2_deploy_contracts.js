var StarNotary = artifacts.require("./StarNotary.sol");

module.exports = function(deployer) {
  deployer.deploy(StarNotary, "ERC-TOKEN-NAME", "ERC-SYMBLE");
};
