const Token = artifacts.require("Token");

module.exports = function(deployer) {
  deployer.deploy(Token, 'Test', 'TST', 2 ,50000, 10000)
};
