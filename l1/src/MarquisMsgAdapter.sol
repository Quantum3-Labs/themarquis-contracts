pragma solidity ^0.8.21;

import {IStarknetMessaging} from "./interfaces/IStarknetMessaging.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IMarquisMsgAdapter} from "./interfaces/IMarquisMsgAdapter.sol";
import {Felt, FeltLibrary} from "./types/Felt.sol";

/**
 * @title MarquisMsgAdapter
 * @author Carlos Ramos
 * @dev this contract will interact with starknet core contract to send and consume messages to / from l2
 */

contract MarquisMsgAdapter is IMarquisMsgAdapter, Initializable, OwnableUpgradeable {
    using FeltLibrary for uint256;

    uint256 constant DEPOSIT_SELECTOR_L2 = 0x002ec0df5118cf86d0032373d25506cff9e952ef881e2d6729f57356c766120e; // keccak256("l1_deposit_handler")
    IStarknetMessaging public starknetMessaging;
    address l2MsgAdapterAddr;
    address VaultAddr;

    modifier onlyVault() {
        require(msg.sender == VaultAddr, "MarquisMsgAdapter: Only Vault contract can call this function");
        _;
    }

    function initialize(address _starknetMessagingAddr, address _l2MsgAdapterAddr, address _VaultAddr)
        external
        initializer
    {
        starknetMessaging = IStarknetMessaging(_starknetMessagingAddr);
        l2MsgAdapterAddr = _l2MsgAdapterAddr;
        VaultAddr = _VaultAddr;
    }

    function transmitDeposit(uint256 _amount, address _l2Receipient) external override onlyVault {
        uint256[] memory payload = new uint256[](3);
        (Felt _amount_high, Felt _amount_low) = _amount.to2Felt();
        payload[0] = Felt.unwrap(_amount_high);
        payload[1] = Felt.unwrap(_amount_low);
        payload[2] = uint256(uint160(_l2Receipient)); // @safe-cast always a felt
        starknetMessaging.sendMessageToL2(uint256(uint160(l2MsgAdapterAddr)), DEPOSIT_SELECTOR_L2, payload);
    }
}
