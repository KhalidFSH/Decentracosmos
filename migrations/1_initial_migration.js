var Migrations = artifacts.require("./utils/Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
