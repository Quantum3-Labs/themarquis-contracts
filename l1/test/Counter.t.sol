// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function test_two(uint256 x, uint256 y) public {}

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    //  fn msg_handler_value(ref self: ContractState, from_address: felt252, value: felt252)
    function testGetSelector() public {
        console.logBytes32(
            bytes32(0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                & keccak256("l1_deposit_handler")
        );
        // console.logUint(uint256(keccak256("function_name")) & (1 << 252));
        //soldity
        require(bytes4(keccak256("testGetSelector()")) == this.testGetSelector.selector);
    }
}
