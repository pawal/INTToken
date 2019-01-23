pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "../contracts/INTToken.sol";

contract TestINTToken {
  INTToken private _intToken;
  address private _owner;

  function TestINTToken() public {
      _owner = msg.sender;
  }

  function beforeEach() public {
      _intToken = new INTToken(this);
  }

//   function test_constructor() public {
//     uint allocatedTokens = _intToken.balanceOf(this);
//     Assert.equal(allocatedTokens, 1000000000, "Contract creator should hold 10000 tokens");
//   }

//   function test_totalSupply() public {
//     uint totalSupply = _intToken.totalSupply();
//     Assert.equal(totalSupply, 1000000000, "There should be 1000000000 tokens in circulation");
//   }

}
