pragma solidity ^0.4.17;
/*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  function balanceOf(address who) public constant returns (uint);
  function allowance(address owner, address spender) public constant returns (uint);

  function transfer(address to, uint value) public returns (bool ok);
  function transferFrom(address from, address to, uint value) public returns (bool ok);
  function approve(address spender, uint value) public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract TokigToken is ERC20 {
    string public constant symbol = "TOK";
    string public constant name = "Den tokigaste tokenen";
    uint8 public constant decimals = 18;
    uint256 totalSupply = 1000000;
    address public owner;
    
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function TokigToken() public{
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _amount) public returns (bool ok) {
        if (balances[msg.sender] >= _amount && _amount > 0) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint _amount ) public returns (bool success) {
        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function approve(address _spender, uint _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}

contract tokigCaller {
	struct transfer {
		TokigToken coinContract;
		uint amount;
		address sender;
		address recipient;
		bool successful;
		uint balance;
	}
	mapping(uint => transfer) transfers;
	uint numTransfers;
	address owner;
	address tokenContract;
	
	function () public {
	    revert();
	}
	
	function tokigCaller(address token) public {
	    owner = msg.sender;
	    tokenContract = token;
	    
	}
	function sendCoin(address receiver, uint amount) public returns(uint) {
		transfer storage t = transfers[numTransfers]; //Creates a reference t
		t.coinContract = TokigToken(tokenContract);
		t.amount = amount;
		t.recipient = receiver;
		t.successful = t.coinContract.transfer(receiver, amount);
		numTransfers++;
		return numTransfers;
	}
	
	function transferCoin(address receiver, uint amount) public returns(uint) {
		transfer storage t = transfers[numTransfers]; //Creates a reference t
		t.coinContract = TokigToken(tokenContract);
		t.amount = amount;
		t.sender = msg.sender;
		t.recipient = receiver;
		t.successful = t.coinContract.transferFrom(msg.sender, this, amount);
		t.coinContract.transfer(receiver, amount);
		numTransfers++;
		return numTransfers;
	}

	
	function getTrans(uint trans) public constant returns(uint amount, bool successful) {
	    amount = transfers[trans].amount;
	    successful = transfers[trans].successful;
	    return (amount, successful);
	}
}

