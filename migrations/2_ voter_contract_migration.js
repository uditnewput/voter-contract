const VoterContract = artifacts.require("VoterContract");

module.exports = function (deployer) {
  deployer.deploy(VoterContract);
};
