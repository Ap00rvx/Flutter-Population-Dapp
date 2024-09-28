const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const Population = artifacts.require("Population");

module.exports = function (deployer) {
  // Deploy Population contract
  deployer.deploy(Population);

  // Deploy ConvertLib and link it to MetaCoin
  deployer.deploy(ConvertLib).then(function() {
    deployer.link(ConvertLib, MetaCoin);
    return deployer.deploy(MetaCoin);
  });
};
