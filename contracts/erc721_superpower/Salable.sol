pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol';

/**
 * @title Salable contract to make ERC721 tokens built-in store.
 * @dev 
 */
contract Salable is ERC721Enumerable {

    mapping(uint256 => uint256) public tokenForSalePrice;
    mapping(uint256 => address) private _ownerOfSallingToken;
    mapping(uint256 => uint256) private _tokenForSaleIndex;
    uint256[] public tokenForSale;

    event TokenUpForSale(address saller, uint starId, uint price);
    event TokenRetrieved(address retreiver, uint starId);

    modifier onlyOwnerOf(uint _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }
    modifier onlySallerOf(uint _tokenId) {
        require(_ownerOfTokenUpForSale(_tokenId) == msg.sender);
        _;
    }
    modifier mostBeForSale(uint _tokenId) {
        require(tokenForSalePrice[_tokenId] > 0);
        _;
    }

    function _addTokenUpForSale(uint256 _tokenId, uint256 _price) internal onlyOwnerOf(_tokenId) {
        tokenForSalePrice[_tokenId] = _price;
        _ownerOfSallingToken[_tokenId] = msg.sender;

        _tokenForSaleIndex[_tokenId] = tokenForSale.length;
        tokenForSale.push(_tokenId);

    }

    function cancelTokenSale(uint _tokenId) public onlySallerOf(_tokenId) {
        _removeTokenFromSale(_tokenId);
    }

    function _bayTokenFromSale(uint256 _tokenId, uint256 payed) internal mostBeForSale(_tokenId) {
        uint256 tokenPrice = tokenForSalePrice[_tokenId];
        address payable tokenOwner = _makePayableAddrss(_ownerOfSallingToken[_tokenId]);

        require(payed >= tokenPrice);

        _transferFrom(tokenOwner, msg.sender, _tokenId);

        tokenOwner.transfer(tokenPrice);
        if(payed > tokenPrice) {
            msg.sender.transfer(payed - tokenPrice);
        }
        _removeTokenFromSale(_tokenId);
    }

    function _ownerOfTokenUpForSale(uint256 tokenId) private view returns (address) {
        address owner = _ownerOfSallingToken[tokenId];
        return owner;
    }

    function _removeTokenFromSale(uint256 _tokenId) private {
        delete tokenForSalePrice[_tokenId];
        delete _ownerOfSallingToken[_tokenId];

        uint256 tokenIndex = _tokenForSaleIndex[_tokenId];
        uint256 lastTokenIndex = tokenForSale.length.sub(1);
        uint256 lastToken = tokenForSale[lastTokenIndex];

        tokenForSale[tokenIndex] = lastToken;
        tokenForSale[lastTokenIndex] = 0;

        tokenForSale.length--;
        _tokenForSaleIndex[_tokenId] = 0;
        _tokenForSaleIndex[lastToken] = tokenIndex;
    }
    
    function _makePayableAddrss(address x) internal pure returns (address payable) {
      return address(uint160(x));
    }
}
