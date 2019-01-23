var INTToken = artifacts.require("./INTToken.sol");
var Revocation = artifacts.require("./Revocation.sol");

module.exports = function(deployer) {
    deployer.deploy(INTToken);
    deployer.deploy(Revocation);
}
