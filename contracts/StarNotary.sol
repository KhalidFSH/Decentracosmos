pragma solidity ^0.5.0;
//pragma experimental ABIEncoderV2;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import './erc721_superpower/Salable.sol';
import './erc721_superpower/Exchangable.sol';
import './univarse/Cosmos.sol';

/**
 * @title Stars Notray ERC721 Non-Fungible Token,
 * which implement a decentralize cosmos system see './univarse' folder.
 * @dev For:Reviewer: If you have no time don't review all files, 
 * I just did some extra work, I couldn't stop my ego OO.
 */
contract StarNotary is ERC721Full('Decentracosmos', 'MOS'), Salable, Exchangable, Cosmos {

    /// Mapping from token Id to a Star.
    mapping(uint256 => Star) public tokenIdToStarInfo;

    /// Events for Star sale 
    event StarUpForSale(address indexed saller, uint indexed starId, uint price);
    event PayedAStar(address indexed bayer, uint256 indexed starId);

    /// Events for Star Exchange.
    event StarUpForExchange(address indexed saller, uint indexed starIdToExchange);
    event StarsExchanged(address indexed exchanger, uint indexed exchangedStarId, uint indexed gettingStarId);

    /**
    * @dev Throws if called by any account other than the owner of a token.
    * @param _tokenId Star's tokenId to check ownerty if it by the sender message. 
    */
    modifier onlyOwnerOf(uint _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }
    

    /**
    * @dev Public function to create a new Star by any one want to.
    * @param _name Star's name.
    * @param _tokenId token Id of a star token to save by in `tokenIdToStarInfo` map and ERC721 storage.
    * @notice `_tokenId` should be uniqe and it'll be changed in future and will be created by the contract itself.
    */
    function createStar(string memory _name, uint256 _tokenId) public {
        uint256 starIndex = createStar(_name);

        tokenIdToStarInfo[_tokenId] = _stars[starIndex];
        _mint(msg.sender, _tokenId);
    }

    /**
    * @dev look up a Star name by its token Id.
    * @param _tokenId Star's token Id to look up into it.
    * @return Star's name as String data type.
    */
    function lookUptokenIdToStarName(uint _tokenId) external view returns(string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }

    /**
    * @dev look up a Star's info by its token Td.
    * @param _tokenId Star token Id to look up into it.
    * @return Star's Info as Star object data type.
    * @notice this function will work only when importing ABIEncoderV2 
    * whiches currently in experimental mode.
    */
    // function lookUptokenIdToStarInfo(uint _tokenId) external view returns(Star memory) {
    //     return tokenIdToStarInfo[_tokenId];
    // }

    /**
    * @dev Public function to put up a Star for sale.
    * @param _tokenId Star token Id to sale.
    * @param _price Price wanted for the sale process.
    * @notice see './erc271_superpower/salable.sol' for more info about this featcher.
    */
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        _addTokenUpForSale(_tokenId, _price);
        emit StarUpForSale(msg.sender, _tokenId, _price);
    }

    /**
    * @dev Public function to bay a payable Star for sale.
    * @param _tokenId Star token Id to bay.
    * @notice see './erc271_superpower/salable.sol' for more info about this featcher.
    */
    function buyStar(uint256 _tokenId) public payable {
        _bayTokenFromSale(_tokenId, msg.value);
        emit PayedAStar(msg.sender, _tokenId);
    }

    /**
    * @dev Public function to ask or put a Star for exchange.
    * @param _tokenId Star token Id to exchange.
    * @notice see './erc271_superpower/exchangable.sol' for more info about this featcher.
    */
    function exchangeStars(uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        if (_tokenExchanger == address(0)){
            _tryToExchange(_tokenId);
            emit StarUpForExchange(msg.sender, _tokenId);
        } else {
            emit StarsExchanged(_tokenExchanger, tokenForExchange, _tokenId);
            emit StarsExchanged(msg.sender, _tokenId, tokenForExchange);
            _tryToExchange(_tokenId);
        }
    }

    /**
    * @dev Public function to transfair a Star to distnation address.
    * @param _to Star token Id to be transfaired.
    * @param _tokenId Star token Id to exchange.
    * @notice see opeanzeppelin doc for more info about this featcher.
    */
    function transfairAStar(address _to, uint _tokenId) external onlyOwnerOf(_tokenId) {
        safeTransferFrom(msg.sender, _to, _tokenId);      
    }
}