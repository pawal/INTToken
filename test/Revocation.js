var INTToken = artifacts.require('./INTToken.sol')
var Revocation = artifacts.require('./Revocation.sol')

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Some sanity tests against the Zeppelin standard token contract
 */
contract('INTToken', (accounts) => {
    it('INTToken should deploy', () => {
      return INTToken.deployed()
      .then((instance) => {
        assert.notEqual(instance, null, 'INTToken instance should not be null')
      })
    })

contract('Revocation', (accounts) => {
  var creatorAddress = accounts[0];
  var recipientAddress = accounts[1];
  var delegatedAddress = accounts[2];
  var _decimals = 18;
  var _total = 1000000000;
  var _supply = _total * 10 ** _decimals;

  it('Revocation should deploy', () => {
    return Revocation.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Revocation instance should not be null')
    })
  })

  it('should have correct initial values set.', async () => {
    let token = await INTToken.deployed()
    let rev = await Revocation.deployed()

    // set token address to the deployed token address
    await rev.Initialize(token.address, creatorAddress, 1)
    let cost = await rev.getCost()
    assert.equal(1, cost)
  })

  // set up accounts and transfer tokens to them

  // set up allowance

  // revoke something

})
})
