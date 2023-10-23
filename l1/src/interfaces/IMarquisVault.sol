pragma solidity ^0.8.18;

interface IMarquisVault {
    function deposit(uint256, address, address) external;

    function stake(uint256, address) external;
}
