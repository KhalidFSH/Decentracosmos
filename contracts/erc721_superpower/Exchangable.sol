pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol';

/**
 * @title Exchangable contract to make any ERC721 tokens exchangable.
 * @dev For now it's only allowed to make randome exchanges as 1 to 1,
 * the firest who ask is who can get it.
 */
contract Exchangable is ERC721Enumerable {
    
    uint256 public tokenForExchange;
    address internal _tokenExchanger;

    modifier onlyOwnerOf(uint _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }
    modifier onlyExchangerOf(uint _tokenId) {
        require(_exchangerOfToken() == msg.sender);
        _;
    }
    modifier onlyOfType(string storage _type) {
        _;
    }
    modifier onlyOfLevel(uint _level) {
        _;
    }

    function _tryToExchange(uint _tokenId) internal onlyOwnerOf(_tokenId) {
        if (tokenForExchange == 0) {
            _addTokenToExchange(_tokenId);
        }
        else {
            _transferFrom(msg.sender, _tokenExchanger, _tokenId);
            _transferFrom(_tokenExchanger, msg.sender, tokenForExchange);
            _removeTokenFromExchange();
        }
    }
    
    function _removeTokenFromExchange() private {
        delete tokenForExchange;
        delete _tokenExchanger;
    }

    function _addTokenToExchange(uint _tokenId) private {
        tokenForExchange = _tokenId;
        _tokenExchanger = msg.sender;
    }

    function cancelExgange(uint _tokenId) public onlyExchangerOf(_tokenId) {
        _removeTokenFromExchange();
    }

    function _exchangerOfToken() private view returns(address){
        return _tokenExchanger;
    }
}