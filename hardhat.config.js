require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/2e1a9c01b1cd43af9641adb134507ee4",
      accounts: [process.env.PRIVATE_KEY],
    }
  }
};
