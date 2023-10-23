pragma solidity ^0.8.18;
import {IMarquisVault} from "./interfaces/IMarquisVault.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IMarquisMsgAdapter} from "./interfaces/IMarquisMsgAdapter.sol";

contract MarquisVault is IMarquisVault, Initializable, OwnableUpgradeable {
    IMarquisMsgAdapter public marquisMsgAdapter;

    function initialize() external initializer {
        __Ownable_init(msg.sender);
    }

    function deposit(
        uint256 _amount,
        address _stableCoin,
        address _l2Recipient
    ) external override {
        // TODO :
        // allocate tokens in strategy contract
        _deposit(_amount, _l2Recipient);
    }

    function stake(uint256 _amount, address _stableCoin) external override {
        // TODO :
        // allocate tokens in strategy contract
        _deposit(_amount, address(0)); //  replace address with Vault contract in l2
    }

    function _deposit(uint256 _amount, address _l2Receipient) internal {
        marquisMsgAdapter.transmitDeposit(_amount, _l2Receipient);
    }
}
