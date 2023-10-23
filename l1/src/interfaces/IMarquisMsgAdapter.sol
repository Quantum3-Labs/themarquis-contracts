pragma solidity ^0.8.18;

interface IMarquisMsgAdapter {
    function transmitDeposit(uint256, address) external;
}
