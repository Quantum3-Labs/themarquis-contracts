pragma solidity ^0.8.20;

type Felt is uint256;

library FeltLibrary {
    uint256 constant FELT_MODULUS = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    function to2Felt(uint256 value) internal pure returns (Felt, Felt) {
        return (Felt.wrap(value >> 252), Felt.wrap(value & (((1 << 252)) - 1)));
    }
}
