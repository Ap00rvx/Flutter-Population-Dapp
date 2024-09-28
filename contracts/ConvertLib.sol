// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library ConvertLib {
    function convert(uint256 amount, uint256 conversionRate) public pure returns (uint256) {
        return amount * conversionRate;
    }
}
