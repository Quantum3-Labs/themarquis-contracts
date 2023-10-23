pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MarquisMsgAdapter} from "../src/MarquisMsgAdapter.sol";

contract DeployScript is Script {
    address constant STARKNET_CORE_GOERLI =
        0xde29d060D45901Fb19ED6C6e959EB22d8626708e;
    address constant L2_MSG_ADAPTER =
        0xde29d060D45901Fb19ED6C6e959EB22d8626708e;

    function setUp() public {
        uint256 deployerPk = vm.envUint("DEPLOYER_PK");
        vm.startBroadcast(deployerPk);
        MarquisMsgAdapter marquisMsgAdapter = new MarquisMsgAdapter(
            STARKNET_CORE_GOERLI,
            L2_MSG_ADAPTER
        );
        vm.stopBroadcast();
    }

    function run() public {}
}
