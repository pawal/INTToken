pragma solidity ^0.4.17;

import "./INTToken.sol";

contract Revocation {
    INTToken tokenContract;
    struct RevocationObj {
        uint id;
        uint prev;
        string revocation;
    }
    uint counter;
    uint cost; // cost of Revocations
    address receiver;
    address owner;
    bool initialized;

    mapping (string => uint) idRevocation;
    mapping (uint => RevocationObj) RevocationChain;

    event RevokeLog(string indexed hash, string revocation);

    // constructor
    function Revocation() public {
        owner = msg.sender;
    }

    function Initialize(address _contract, address _receiver, uint _cost) public {
        require(owner == msg.sender);
        require(_contract != 0x0);
        require(_receiver != 0x0);
        require(_cost > 0);
        cost = _cost;
        receiver = _receiver;
        tokenContract = INTToken(_contract);
        initialized = true;
    }

    function Revoke(string _hash, string _revocation) public {
        require(initialized);
        require(bytes(_hash).length != 0);
        require(bytes(_revocation).length != 0);
        counter++;
        RevocationChain[counter] = RevocationObj(counter,idRevocation[_hash],_revocation);
        idRevocation[_hash] = counter;
        RevokeLog(_hash, _revocation);
        tokenContract.transferFrom(msg.sender, this, cost);
    }
    
    function GetCounter() public constant returns (uint) {
        return counter;
    }

    function GetRevocationId(string _key) public constant returns (uint id) {
        return idRevocation[_key];
    }

    function GetRevocation(uint _id) public constant returns (string revocation, uint prev) {
        return (RevocationChain[_id].revocation, RevocationChain[_id].prev);
    }

    function getCost() constant public returns(uint) {
        return cost;
    }

    function widthdrawTokens(uint _amount) public {
        require(msg.sender == owner);
        require(_amount > 0);
        tokenContract.transfer(receiver, _amount);
    }

}
