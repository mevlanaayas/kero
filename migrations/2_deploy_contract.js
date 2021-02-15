var ActivityContract   = artifacts.require("./ActivityContract.sol");

module.exports = function(deployer) {
    deployer.deploy(ActivityContract,true,true);
};
