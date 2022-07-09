// SPDX-License-Identifier: None
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BzzBondingCurve {
    using SafeMath for uint256;

    // Curve mathematical functions
    uint256 internal constant _BZZ_SCALE = 1e16;
    uint256 internal constant _N = 5;
    uint256 internal constant _MARKET_OPENING_SUPPLY = 62500000 * _BZZ_SCALE;

    constructor() {}

    function buyPrice(uint256 _amount, uint256 _totalSupply)
        public
        pure
        returns (uint256 collateralRequired)
    {
        collateralRequired = _mint(_amount, _totalSupply);
        return collateralRequired;
    }

    function _mint(uint256 _amount, uint256 _currentSupply)
        internal
        pure
        returns (uint256)
    {
        uint256 deltaR = _primitiveFunction(_currentSupply.add(_amount)).sub(
            _primitiveFunction(_currentSupply)
        );
        return deltaR;
    }

    function _helper(uint256 x) internal pure returns (uint256) {
        for (uint256 index = 1; index <= _N; index++) {
            x = (x.mul(x)).div(_MARKET_OPENING_SUPPLY);
        }
        return x;
    }

    function _primitiveFunction(uint256 s) internal pure returns (uint256) {
        return s.add(_helper(s));
    }

    function sellReward(uint256 _amount, uint256 _totalSupply)
        public
        pure
        returns (uint256 collateralReward)
    {
        (collateralReward, ) = _withdraw(_amount, _totalSupply);
        return collateralReward;
    }

    function _withdraw(uint256 _amount, uint256 _currentSupply)
        internal
        pure
        returns (uint256, uint256)
    {
        assert(_currentSupply - _amount > 0);
        uint256 deltaR = _primitiveFunction(_currentSupply).sub(
            _primitiveFunction(_currentSupply.sub(_amount))
        );
        uint256 realized_price = deltaR.div(_amount);
        return (deltaR, realized_price);
    }
}
