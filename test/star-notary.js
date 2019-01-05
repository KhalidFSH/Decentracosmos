const StarNotary = artifacts.require('./StarNotary.sol')
var BN = web3.utils.BN
contract('StarNotary', async (accounts) => {
  let instance
  beforeEach('setup contract for each test', async function () {
    instance = await StarNotary.deployed();
  });

  it("deployed with token name='Decentracosmos'and token symbol='MOS'", async() => {
    assert.equal(await instance.name.call(), 'Decentracosmos')
    assert.equal(await instance.symbol.call(), 'MOS')

  });

  it('can Create a Star', async() => {
    let tokenId = 1;
    await instance.createStar('Awesome Star!', tokenId, {from: accounts[0]})
    assert.equal(await instance.lookUptokenIdToStarName.call(tokenId), 'Awesome Star!')
  });

  it('lets user1 put up their star for sale', async() => {
    let user1 = accounts[1]
    let starId = 2;
    let starPrice = web3.utils.toWei('0.01', "ether")
    await instance.createStar('awesome star', starId, {from: user1})
    await instance.putStarUpForSale(starId, starPrice, {from: user1})
    assert.equal(await instance.tokenForSalePrice.call(starId), starPrice)
  });

  it('lets user1 get the funds after the sale', async() => {
    let user1 = accounts[1]
    let user2 = accounts[2]
    let starId = 3
    let starPrice = web3.utils.toWei('0.01', "ether")
    await instance.createStar('awesome star', starId, {from: user1})
    await instance.putStarUpForSale(starId, starPrice, {from: user1})
    let balanceOfUser1BeforeTransaction = parseInt(await web3.eth.getBalance(user1))
    await instance.buyStar(starId, {from: user2, value: starPrice})
    let balanceOfUser1AfterTransaction =parseInt(await  web3.eth.getBalance(user1))
    assert.equal(balanceOfUser1BeforeTransaction + parseInt(starPrice), balanceOfUser1AfterTransaction);
  });

  it('lets user2 buy a star, if it is put up for sale', async() => {
    let user1 = accounts[1]
    let user2 = accounts[2]
    let starId = 4
    let starPrice = web3.utils.toWei('0.01', "ether")
    await instance.createStar('awesome star', starId, {from: user1})
    await instance.putStarUpForSale(starId, starPrice, {from: user1})
    await instance.buyStar(starId, {from: user2, value: starPrice});
    assert.equal(await instance.ownerOf.call(starId), user2);
  });

  it('lets user2 buy a star and decreases its balance in ether', async() => {
    let user1 = accounts[1]
    let user2 = accounts[2]
    let starId = 5
    let starPrice = web3.utils.toWei('0.01', "ether")
    await instance.createStar('awesome star', starId, {from: user1})
    await instance.putStarUpForSale(starId, starPrice, {from: user1})
    let balanceOfUser2BeforeTransaction = parseInt(await web3.eth.getBalance(user2))
    await instance.buyStar(starId, {from: user2, value: starPrice, gasPrice:0})
    let balanceAfterUser2BuysStar = parseInt(await web3.eth.getBalance(user2))
    assert.equal((balanceOfUser2BeforeTransaction - balanceAfterUser2BuysStar), parseInt(starPrice));
  });

  it('let 2 users exchange their stars', async() => {
    let user1 = accounts[1]
    let user2 = accounts[2]
    let starId1 = 6
    let starId2 = 7
    await instance.createStar('awesome star for exchange 1', starId1, {from: user1})
    await instance.createStar('awesome star for exchange 2', starId2, {from: user2})
    await instance.exchangeStars(starId1, {from: user1})
    await instance.exchangeStars(starId2, {from: user2})
    assert.equal(await instance.ownerOf.call(starId1), user2)
    assert.equal(await instance.ownerOf.call(starId2), user1)
  });

  it('can transfair a star by owner to another address', async () => {
    let owner = accounts[1]
    let recever = accounts[2]
    let starId = 8
    await instance.createStar('awesome star for transfaier to a lover', starId, {from: owner})
    await instance.transfairAStar(recever, starId, {from: owner})
    assert.equal(await instance.ownerOf.call(starId), recever)
  });

});