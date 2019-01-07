pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './Galaxies.sol';

contract Cosmos is Galaxies, Ownable{
    uint birthTime = now;
    
    Galaxy[] public _deployedGalaxies;

    function _createGalaxy() internal {
        super._createGalaxy();
    }

    function _deployGalaxy() private {
        _deployedGalaxies.push(_currentGalaxy);
    }

    function createStar(string memory _name) internal returns(uint256) {
        if (_currentGalaxy.birthTime == 0 ) {
            _createGalaxy();
        }
        else if (_isGalaxyBigBangEnded(_currentGalaxy)) {
            _deployGalaxy();
            _createGalaxy();
        }
        uint256 starIndex = _createStar(_name);
        _currentGalaxy.starsId.push(starIndex);
        return starIndex;
    }

    function _isGalaxyBigBangEnded(Galaxy storage _galaxy) private view returns(bool){
        uint galaxyDays = _galaxy.thickness.mod(1000);
        uint galaxyTime = galaxyDays.mul(1 days);
        uint256 timeFomBegin = now.sub(_galaxy.birthTime);
        return (timeFomBegin < galaxyTime);  
    }

    function domsDay() external onlyOwner {
        for (uint256 i = 0; i < _deployedGalaxies.length; i++) {
            for (uint256 j = 0; j < _deployedGalaxies[i].starsId.length; j ++) {
                delete _stars[_deployedGalaxies[i].starsId[j]];
            }
            delete _deployedGalaxies[i];
        }
    }
}