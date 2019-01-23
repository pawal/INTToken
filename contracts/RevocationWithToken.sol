pragma solidity ^0.4.17;

import "./INTToken.sol";

contract RevocationWithToken {
    mapping (string => string) _revocations;
	uint numRevocations; // if we want total number of revocations
	INTToken tokenContract;
	uint cost; // cost of Revocations
	address receiver;
	address owner;

    event RevokeLog(string indexed hash, string revocation);

    // _contract is the address of the deployed INT tokenContract
    // _receiver is the address that is allowed to withdraw tokens from this contract
    // _cost is the cost for doing revocations
    function RevocationWithToken(address _contract, address _receiver, uint _cost) public {
        assert(cost > 0 && _receiver != 0x0);
        cost = _cost;
        receiver = _receiver;
        owner = msg.sender;
        tokenContract = INTToken(_contract);
    }

    function Revoke(string _hash, string _revocation) public {
        assert(bytes(_hash).length != 0);
        assert(bytes(_revocation).length != 0);
        tokenContract.totalSupply();
        _revocations[_hash] = _revocation;
        tokenContract.transferFrom(msg.sender, this, cost);

        numRevocations++;
    }

    function getRevoked(string _hash) constant public returns(string) {
        return _revocations[_hash];
    }
    
    function getCost() constant public returns(uint) {
        return cost;
    }
    
    function getNumRevocations() constant public returns(uint) {
        return numRevocations;
    }
    
    function widthdrawTokens(uint _amount) public {
        assert(msg.sender == owner);
        assert(_amount > 0);
        tokenContract.transfer(receiver, _amount);
    }
}
