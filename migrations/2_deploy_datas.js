var CustomerAccount = artifacts.require("./CustomerAccount.sol");
var CustomerContract = artifacts.require("./CustomerContract.sol");
var CustomerTransaction = artifacts.require("./CustomerTransaction.sol");
var Config = artifacts.require("./Config.sol");

module.exports = function(deployer) {
    deployer.deploy(CustomerAccount);
    deployer.deploy(CustomerContract);
    deployer.deploy(CustomerTransaction);
    deployer.deploy(Config);
};
