pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract Stars {
    using SafeMath for uint256;
    using SafeMath for uint8;

    Star[] internal _stars;
    enum StellarClass {O, B, A, F, G, K, M}
    struct Star {
        string name;
        uint birthTime;
        uint8 angle;
        uint8 layer;
        StellarClass class;
        uint8 level;
    }

    function _createStar(string memory _name, uint _galaxyLayers) internal  returns(uint256){
        Star memory newStar;
        uint random = uint(keccak256(abi.encodePacked(_name, msg.sender, now)));
        newStar.name = _name;
        newStar.birthTime = now;
        newStar.angle = uint8(random.mod(256));
        newStar.layer = uint8(random.mod(_galaxyLayers));
        newStar.class = StellarClass(random.mod(7));
        newStar.level = uint8(random.mod(10));
        return (_stars.push(newStar) -1);
    }

}