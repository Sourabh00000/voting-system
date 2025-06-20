// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    address public admin;
    bool public votingStarted;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool registered;
        bool voted;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public candidatesCount;

    constructor() {
        admin = msg.sender;
        votingStarted = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function registerCandidate(string memory _name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function registerVoter(address _voter) public onlyAdmin {
        voters[_voter] = Voter(true, false);
    }

    function startVoting() public onlyAdmin {
        votingStarted = true;
    }

    function vote(uint _candidateId) public {
        require(votingStarted, "Voting has not started yet");
        require(voters[msg.sender].registered, "You are not registered to vote");
        require(!voters[msg.sender].voted, "You have already voted");

        voters[msg.sender].voted = true;
        candidates[_candidateId].voteCount++;
    }

    function getWinner() public view returns (string memory) {
        uint maxVotes = 0;
        uint winnerId;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return candidates[winnerId].name;
    }
}
