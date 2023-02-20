// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Logarithm {
    uint constant UNIT = 10 ** 18;
    uint constant PRECISION = 60;
    uint constant MAX_ITERATIONS = 30;
    
    function log2(uint x) public pure returns (int) {
        require(x >= UNIT, "x must be greater than or equal to UNIT");
        
        int result = int(PRECISION) * int(2 ** 64);
        uint y = x;
        uint z = 0;
        
        while (y < UNIT * 2) {
            y <<= 1;
            result -= int(1 << 64);
        }
        
        for (uint8 i = 0; i < MAX_ITERATIONS; i++) {
            y = (y * y) / x;
            z = y >> (PRECISION - 1);
            if (z > 0) {
                result += int(1 << (PRECISION - 1 - z));
                y = y >> z;
            }
        }
        
        return result;
    }
}
