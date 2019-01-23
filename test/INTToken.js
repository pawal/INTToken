var INTToken = artifacts.require("INTToken");
//var standardtoken = artifacts.require("StandardToken")

contract('INTToken', (accounts) => {

  var creatorAddress = accounts[0];
  var recipientAddress = accounts[1];
  var delegatedAddress = accounts[2];
  var _decimals = 18;
  var _total = 1000000000;
  var _supply = _total * 10 ** _decimals;

  // test token creation
  it("should contain 1000000000 INT tokens in circulation", () => {
    return INTToken.deployed().then((instance) => {
      return instance.totalSupply.call();
    }).then(balance => {
      assert.equal(balance.valueOf(), _supply, "1000000000 INT tokens are not in circulation");
    });
  });

  // test creator balance
  it("should contain 1000000000 INT in the creator balance", () => {
    return INTToken.deployed().then(instance => {
      return instance.balanceOf.call(creatorAddress);
    }).then(balance => {
      assert.equal(balance.valueOf(), _supply, "1000000000 wasn't in the creator balance");
    });
  });

  // test transfer of tokens
  it("should transfer 1000 INT tokens to the recipient balance", () => {
    var myToken;
    return INTToken.deployed().then(instance => {
      myToken = instance;
      return myToken.transfer(recipientAddress, 1000, {from: creatorAddress});
    }).then(result => {
      return myToken.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1000, "1000 wasn't in the recipient balance");
      return myToken.balanceOf.call(creatorAddress);
    }).then(creatorBalance => {
      assert.equal(creatorBalance.valueOf(), _supply-1000, "999999000 wasn't in the creator balance");
    });
  });

  it("should approve 500 INT tokens to the delegated balance", () => {
    var myToken;
    return INTToken.deployed().then(instance => {
      myToken = instance;
      return myToken.approve(delegatedAddress, 500, {from: creatorAddress});
    }).then(result => {
      return myToken.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 500, "500 wasn't approved to the delegated balance");
    });
  });

  it("should transfer 200 INT tokens from the creator to the alt recipient via the delegated address", () => {
    var myToken;
    return INTToken.deployed().then(instance => {
      myToken = instance;
      return myToken.transferFrom(creatorAddress, recipientAddress, 200, {from: delegatedAddress});
    }).then(result => {
      return myToken.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1200, "1200 wasn't in the recipient balance");
      return myToken.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 300, "300 wasn't set as the delegated balance");
    });
  });

});
