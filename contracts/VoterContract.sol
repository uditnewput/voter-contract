// SPDX-License-Identifier: unlicense
pragma solidity 0.8.0;

contract VoterContract {
    struct Candidate {
        string _firstName;
        string _lastName;
        uint8 _id;
        uint256 _votes;
    }
    mapping(uint => Candidate) public candidates;
    uint8 public candidateCount = 0; // uint because we will only have 4 candidates as mentioned, we can also allow to set number of candidates from owner

    struct Voter {
        string _firstName;
        string _lastName;
        uint256 _id;
        bool _isVerified;
    }
    mapping(address => Voter) voters;
    uint256 voterCount = 0;

    uint256 public openingTime;
    uint256 public closingTime;
    // uint256 public duration;

    uint256 totalVotes = 0;
    uint8 winningCandidateID; // assign this to default candidate numbers + 1
    uint256 winningVoteCount = 0;

    address ownerAddress;

    struct Winner {
        uint8 _winnerID;
        uint256 _winningPercentage;
        string _status;
    }

    constructor(uint openingTimeInSeconds, uint durationInSeconds) {
        ownerAddress = msg.sender;   
        openingTime = openingTimeInSeconds; // block.timestamp + 120;
        // duration = 60; // 300 seconds
        closingTime = openingTime + durationInSeconds;
    }
    
    modifier isOwner {
        require(ownerAddress == msg.sender);
        _;
    }

    modifier isParticipantsAllowed {
        require(openingTime > block.timestamp, "Participants are not allowed now! Bhag jao..");
        _;
    }

    modifier isVotingAllowed {
        require(openingTime < block.timestamp, "Voting is not started yet, why so hurry!!"); // give more appropriate response here
        require(closingTime > block.timestamp, "Voting is finished, you are late!!"); // give more appropriate response here
        _;
    }

    function checkForEmpty(string memory value) internal pure {
        string memory empty = "";
        require(keccak256(abi.encodePacked(value)) != keccak256(abi.encodePacked(empty)));
    }

    function addVoter(string memory _firstName, string memory _lastName) public isParticipantsAllowed { // add check to add an address only once
        checkForEmpty(_firstName);
        checkForEmpty(_lastName);

        voterCount += 1;
        require(voterCount < 100);
        voters[msg.sender] = Voter(_firstName, _lastName, voterCount, false);
    }

    function addCandidates(string memory _firstName, string memory _lastName) public isOwner isParticipantsAllowed { // because contract owner is the one who will give permission for candidates entry
        checkForEmpty(_firstName);
        checkForEmpty(_lastName);
        require(candidateCount < 4); // limiting candidates to 4 as mentioned in assignemnt
        candidates[candidateCount] = Candidate(_firstName, _lastName, candidateCount, 0);
        candidateCount += 1;
    }

    // owner can verify the voters manually
    function verifyVoter(address voterAddress) public isParticipantsAllowed {
        voters[voterAddress]._isVerified = true;
    }

    function vote(uint8 candidateID) public isVotingAllowed {
        // require(candidateID != 0, "Candidate ID is must!!"); // 
        bool isVoterVerified = voters[msg.sender]._isVerified;
        require(isVoterVerified, "Voter has already voted or unverified"); // we can provide more accurate response if needed by adding one more bool in Voter like _hasVoted

        require(candidateID < 4, "Invalid candidate ID!!");
        uint256 votes = candidates[candidateID]._votes;
        candidates[candidateID]._votes = votes + 1;
        if (votes > winningVoteCount) {
            winningVoteCount = votes + 1;
            winningCandidateID = candidateID;
        }
        totalVotes += 1;
    }

    // (winningCandidateVote x 100) / totalNumberofVotes will give percentage of winning
    function checkWinner() public view returns (Winner memory) {
        require(totalVotes > voterCount, "Kuch to gadbad hai daya!"); // if we skip this check then we will save around 34000 gas
        uint256 winningPercentage = (winningVoteCount * 100) / totalVotes;
        if (winningPercentage > 60) {
            return Winner(winningCandidateID, winningPercentage, "WON!!!!");
        }
        return Winner(winningCandidateID, winningPercentage, "Percentage criteria not met!");
    }
}

// 1466620
// 1502162
// 1312812 after removing public from state variiables