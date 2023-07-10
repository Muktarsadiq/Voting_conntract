const { expect } = require("chai");

describe("Voting", function () {
  let Voting;
  let voting;
  let owner;
  let addr1;
  let addr2;
  let candidate1;
  let candidate2;

  beforeEach(async function () {
    Voting = await ethers.getContractFactory("Voting");
    [owner, addr1, addr2, candidate1, candidate2] = await ethers.getSigners();
    voting = await Voting.deploy();
  });


  it("should set the organizer correctly", async function () {
    expect(await voting.organizer()).to.equal(owner.address);
  });

  it("should set the candidate correctly", async function () {
    await voting.connect(owner).setCandidate(candidate1.address, "25", "John");
    const candidateData = await voting.getCandidateData(candidate1.address);
    expect(candidateData[0]).to.equal("25");
    expect(candidateData[1]).to.equal("John");
    expect(candidateData[2]).to.equal(0);
    expect(candidateData[3]).to.equal(1);
    expect(candidateData[4]).to.equal(candidate1.address);
  });

  it("should create voters and allow voting", async function () {
    await voting.connect(owner).voterRight(addr1.address, "Alice", "30");
    await voting.connect(owner).voterRight(addr2.address, "Bob", "35");

    const voterData1 = await voting.getVoterData(addr1.address);
    expect(voterData1[0]).to.equal(1);
    expect(voterData1[1]).to.equal("Alice");
    expect(voterData1[2]).to.equal(addr1.address);
    expect(voterData1[3]).to.equal(false);

    const voterData2 = await voting.getVoterData(addr2.address);
    expect(voterData2[0]).to.equal(2);
    expect(voterData2[1]).to.equal("Bob");
    expect(voterData2[2]).to.equal(addr2.address);
    expect(voterData2[3]).to.equal(false);

    await voting.connect(addr1).vote(candidate1.address, 1);
    await voting.connect(addr2).vote(candidate1.address, 1);

    const candidateData = await voting.getCandidateData(candidate1.address);
    expect(candidateData[2]).to.equal(2);
  });

  it("should return the winner correctly", async function () {
    await voting.connect(owner).setCandidate(candidate1.address, "25", "John");
    await voting.connect(owner).setCandidate(candidate2.address, "30", "Alice");

    await voting.connect(owner).voterRight(addr1.address, "Voter 1", "20");
    await voting.connect(owner).voterRight(addr2.address, "Voter 2", "30");

    await voting.connect(addr1).vote(candidate1.address, 1);
    await voting.connect(addr2).vote(candidate2.address, 2);

    const winnerData = await voting.getWinner();
    expect(winnerData[0]).to.equal(candidate1.address);
    expect(winnerData[1]).to.equal("John");
    expect(winnerData[2]).to.equal(1);
  });
});
