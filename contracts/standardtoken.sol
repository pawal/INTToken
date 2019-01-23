pragma solidity ^0.4.17;
/**
 * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
 *
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
import "./safemath.sol";
import "./erc20.sol";
import "./erc223.sol";
import "./erc223receivingcontract.sol";

contract StandardToken is ERC20, ERC223, SafeMath {
  // Public Variables of the token
  string public _name;
  string public _symbol;
  uint8 public _decimals = 18;
  uint256 public _totalSupply;

  // Actual balances of token holders
  mapping(address => uint) balances;

  // approve() allowances
  mapping (address => mapping (address => uint)) allowed;

  // Interface declaration
  function isToken() public pure returns (bool weAre) {
    return true;
  }

  function StandardToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
      _totalSupply = initialSupply * 10 ** uint256(_decimals);
      balances[msg.sender] = _totalSupply;
      _name = tokenName;
      _symbol = tokenSymbol;
  }

  function transfer(address _to, uint _value) public returns (bool success) {
    require(_to != 0x0 && !isContract(_to)); // Do not transfer to 0x0 or a contract
    require(_to != msg.sender);
    require(balances[msg.sender] >= _value);
    require(balances[_to] + _value > balances[_to]);
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[_to] = safeAdd(balances[_to], _value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transfer(address _to, uint _value, bytes _data) public returns(bool){
    require(_to != 0x0 && isContract(_to)); // Should be transfer to contract
    require(_to != msg.sender);
    require(balances[msg.sender] >= _value);
    require(balances[_to] + _value > balances[_to]);
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[_to] = safeAdd(balances[_to], _value);

    ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
    _contract.tokenFallback(msg.sender, _value, _data);
    Transfer(msg.sender, _to, _value, _data);
    return true;
  }

  // check if receiver address is a contract
  function isContract(address _addr) private constant returns (bool) {
      uint codeSize;
      assembly {
          codeSize := extcodesize(_addr)
      }
      return codeSize > 0;
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
    require(allowed[_from][msg.sender] > 0 && _value > 0);
    require(balances[_from] >= _value);

    uint _allowance = allowed[_from][msg.sender];
    balances[_to] = safeAdd(balances[_to], _value);
    balances[_from] = safeSub(balances[_from], _value);
    allowed[_from][msg.sender] = safeSub(_allowance, _value);
    Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public constant returns (uint balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint _value) public returns (bool success) {
    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    if (allowed[msg.sender][_spender] != 0 && _value != 0) {
      return false;
    }
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }

}
