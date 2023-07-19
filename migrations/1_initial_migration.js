var Migrations = artifacts.require("Migrations");

console.log(" INSIDE DEPLOY 1")

module.exports = function(deployer) {
    deployer.deploy(Migrations);
};
