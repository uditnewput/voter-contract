/*
truffle compile: compile all the contracts present in Contracts folder //
truffle deploy : spins up a local enviornment //
truffle migrate: runs inside a local enviorment This commands executes all the migrations files //

    ?To deploy a contract we need to write migration file

        const Migrations = artifacts.require("Migrations");
        module.exports = function (deployer) {
          deployer.deploy(Migrations);
        };

    ?If you want to deploy multiple contract in same migration file you can use chainable promises like this

        const MyContract = artifacts.require("MyContract");
        const MyContractPermanent = artifacts.require("MyContractPermanent");
        module.exports = function (deployer) {
          deployer.deploy(MyContract, "Udit Jain").then(async () => {
            let instance = await MyContract.deployed();
            let message = instance.getMessage();
            return deployer.deploy(MyContractPermanent, message)
          });
        };

    !inside truffle develop console

        let instance = await MyContract.deployed()  //this is instance for your contract
        instance.setMessage("Udit")
        instance.getMessage()

    ?For a payable function
    instance.setMessage("Udit Jain",{value: web3.utils.toWei("2","ether")})

    ?lets say we want to use other address for say owner checking
    instance.getMessage({from: accounts[2]})  
*/

/*
In Order to deploy to a mainnet or testnet we need to have a private key first
        npx mnemonics : This will generate mnemonics then create a file like secrets.json

        Then in truffle config we need to import that mnemonic
        Then we need to install any HDWallet Provider and npm install it
        we uncommemnt ropsten object or any other than we wish to use and provide our moralis or other project URL of our node at cloud

        Now we need to add some funds inside our newly generated account
        so we need to have an address from our mnemonics and then go to faucet and request funds

        truffle console --network ropsten

        then we run 
        await web3.eth.getAccounts()
        This will bring the list of accounts with our mnemonics and we can copy it and then can get some testnet ether

        await web2.eth.getBalance("whatever address we get")
        after confirming we can run truffle migrate to migrate it to any specified blockchain
*/