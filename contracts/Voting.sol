// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Voting {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public organizer;

    struct Candidate {
        uint256 candiddateId;
        string name;
        string age;
        uint256 voteCount;
        address _address;
    }

    event CreateCandidate(
        uint256 indexed candiddateId,
        string name,
        string age,
        uint voteCount,
        address _address
    );

    address[] public candidateAddress;
    mapping(address => Candidate) candidates;

    address[] public votedVoters;
    address[] public votersAddress;

    mapping(address => Voter) public voters;

    struct Voter {
        uint256 voter_voterId;
        string voter_name;
        address voter_address;
        uint voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
    }

    event VoterCreated(
        uint256 indexed voter_voterId,
        string voter_name,
        address voter_address,
        uint voter_allowed,
        bool voter_voted,
        uint256 voter_vote
    );

    constructor() {
        organizer = msg.sender;
    }

    function setCandidate(
        address _address,
        string memory _age,
        string memory _name
    ) public {
        require(
            organizer == msg.sender,
            "only the organizer can create Candidates"
        );
        _candidateId.increment();
        uint256 idNumber = _candidateId.current();
        Candidate storage candidate = candidates[_address];
        candidate.age = _age;
        candidate.name = _name;
        candidate.candiddateId = idNumber;
        candidate.voteCount = 0;
        candidate._address = _address;

        candidateAddress.push(_address);

        emit CreateCandidate(
            idNumber,
            _age,
            _name,
            candidate.voteCount,
            _address
        );
    }

    function getCandidate() public view returns (address[] memory) {
        return candidateAddress;
    }

    function getCandidateLength() public view returns (uint256) {
        return candidateAddress.length;
    }

    function getCandidateData(address _address)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            address
        )
    {
        return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].voteCount,
            candidates[_address].candiddateId,
            candidates[_address]._address
        );
    }

    function voterRight(address _address, string memory _name) public {
        require(organizer == msg.sender, "only Organizer can create voters.");
        _voterId.increment();
        uint256 idNumber = _voterId.current();
        Voter storage voter = voters[_address];
        require(voter.voter_allowed == 0, "you are not eligible to vote");
        voter.voter_allowed = 1;
        voter.voter_name = _name;
        voter.voter_address = _address;
        voter.voter_voterId = idNumber;
        voter.voter_vote = 1000;
        voter.voter_voted = false;

        votersAddress.push(_address);

        emit VoterCreated(
            idNumber,
            _name,
            _address,
            voter.voter_allowed,
            voter.voter_voted,
            voter.voter_vote
        );
    }

    function vote(address _candidateAddress, uint256 _candidateVoteId)
        external
    {
        Voter storage voter = voters[msg.sender];
        require(!voter.voter_voted, "you have already voted");
        require(voter.voter_allowed != 0, "You are not allowed to vote");
        voter.voter_voted = true;
        voter.voter_vote == _candidateVoteId;

        votedVoters.push(msg.sender);
        candidates[_candidateAddress].voteCount += 1;
    }

    function getVoterLength() public view returns (uint256) {
        return votersAddress.length;
    }

    function getVoterData(address _address)
        public
        view
        returns (
            uint256,
            string memory,
            address,
            bool
        )
    {
        return (
            voters[_address].voter_voterId,
            voters[_address].voter_name,
            voters[_address].voter_address,
            voters[_address].voter_voted
        );
    }

    function getVotedVoterList() public view returns (address[] memory) {
        return votedVoters;
    }

    function getVoterlist() public view returns (address[] memory) {
        return votersAddress;
    }

    function getWinner()
        public
        view
        returns (
            address winnerAddress,
            string memory winnerName,
            uint256 winnerVoteCount
        )
    {
        require(candidateAddress.length > 0, "No candidates found");

        address currentWinnerAddress = candidateAddress[0];
        uint256 currentWinnerVoteCount = candidates[currentWinnerAddress]
            .voteCount;

        for (uint256 i = 1; i < candidateAddress.length; i++) {
            address candidateAddr = candidateAddress[i];
            uint256 voteCount = candidates[candidateAddr].voteCount;

            if (voteCount > currentWinnerVoteCount) {
                currentWinnerAddress = candidateAddr;
                currentWinnerVoteCount = voteCount;
            }
        }

        return (
            currentWinnerAddress,
            candidates[currentWinnerAddress].name,
            currentWinnerVoteCount
        );
    }
}
