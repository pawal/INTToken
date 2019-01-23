pragma solidity ^0.4.17;

import "./standardtoken.sol";

contract INTToken is StandardToken(1000000000, "Integrity Token", "INT") {
    address owner;

    function INTToken(address _owner) public {
        owner = _owner;
    }

    function name() constant public returns(string) {
        return _name;
    }
    
    function symbol() constant public returns(string) {
        return _symbol;
    }
    
    function decimals() constant public returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() constant public returns (uint) {
        return _totalSupply;
    }
    
}
