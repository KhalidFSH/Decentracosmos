pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import './Stars.sol';

contract Galaxies is Stars{
    using SafeMath for uint256;

    enum GalaxyClass {notYet, E, S, L}
 
    Galaxy internal _currentGalaxy;

    struct Galaxy {
        uint birthTime;
        uint8 centerAngle;
        uint8 xAngle;
        uint8 yAngle; 
        uint8 centerLayer;
        uint thickness;
        uint layers;
        uint16 initSpeed;
        uint8 velocitylevel;
        GalaxyClass class;
        uint[] starsId;
    }


    function _createGalaxy() internal {
        Galaxy memory newGalaxy;
        uint _now = now;
        uint random = _generateRandom(_now, uint256(msg.sender), 18181818);
        newGalaxy.birthTime = now;
        newGalaxy.centerAngle = uint8(random.mod(256));
        newGalaxy.xAngle = uint8(_generateRandom(random, _now, 33333).mod(128));
        newGalaxy.yAngle = uint8(_generateRandom(random, _now, 66666).mod(128));
        newGalaxy.centerLayer = uint8(random.mod(10));
        newGalaxy.thickness = random.mod(6000) + 1000;
        newGalaxy.layers = random.mod(_generateRandom(random, _now, 99999).mod(7000));
        newGalaxy.initSpeed = uint16(random.mod(1000));
        newGalaxy.velocitylevel = uint8(random.mod(100));
        newGalaxy.class = GalaxyClass.notYet;
        _currentGalaxy = newGalaxy;
    }

    function _createStar(string memory _name) internal returns(uint256) {
        return _createStar(_name, _currentGalaxy.layers);
    }

    function _generateRandom(uint256 _1, uint256 _2, uint256 _3) private pure returns(uint){
        return uint(keccak256(abi.encodePacked(_1, _2, _3)));
    }
}