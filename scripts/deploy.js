const { ethers } = require("hardhat");

async function main() {
  const Voting = await ethers.getContractFactory("Voting");
  console.log("Deploying Voting contract...");

  const network = "sepolia"; // Specify the network name
  const provider = ethers.getDefaultProvider(network);
  const signer = provider.getSigner();
  const voting = await Voting.connect(signer).deploy();
  await voting.deployed();

  console.log("Voting contract deployed to:", voting.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
