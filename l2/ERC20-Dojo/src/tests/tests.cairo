//Todo: test events

#[cfg(test)]
mod tests {
use dojo_erc::erc20::IERC20;
use core::traits::TryInto;
use integer::BoundedInt;
use integer::u256;
use integer::u256_from_felt252;
use dojo_erc::tests::utils;
use dojo_erc::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, NAME, SYMBOL, DECIMALS, SUPPLY, VALUE,
};
use dojo_erc::erc20::erc_systems::Approval;
use dojo_erc::erc20::erc_systems::ERC20Impl;
use dojo_erc::erc20::erc_systems::{InternalImpl,WorldInteractionsImpl};
use dojo_erc::erc20::erc_systems::Transfer;
use dojo_erc::erc20::erc_systems;
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::testing;
use zeroable::Zeroable;
use dojo::test_utils::{spawn_test_world, deploy_contract};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo_erc::erc20::{IERC20Dispatcher, IERC20DispatcherTrait};

use dojo_erc::erc20_models::{
    ERC20Allowance, erc_20_allowance, ERC20Balance, erc_20_balance, ERC20Meta, erc_20_meta
};
use dojo_erc::erc20::erc_systems::_worldContractMemberStateTrait;
use debug::PrintTrait;



fn STATE() -> (IWorldDispatcher, dojo_erc::erc20::erc_systems::ContractState) {
    let world = spawn_test_world(
        array![
            erc_20_allowance::TEST_CLASS_HASH,
            erc_20_balance::TEST_CLASS_HASH,
            erc_20_meta::TEST_CLASS_HASH,
        ]
    );
    let mut state = dojo_erc::erc20::erc_systems::contract_state_for_testing();
    
    (world, state)
}

    fn setup() -> (IWorldDispatcher, dojo_erc::erc20::erc_systems::ContractState) {
       let world = spawn_test_world(
        array![
            erc_20_allowance::TEST_CLASS_HASH,
            erc_20_balance::TEST_CLASS_HASH,
            erc_20_meta::TEST_CLASS_HASH,
        ]
    );
        let mut state = dojo_erc::erc20::erc_systems::contract_state_for_testing();
        state.initialize(NAME, SYMBOL,world.contract_address);
        utils::drop_event(ZERO());
        (world, state)
    }

// //
// // initializer
// //

#[test]
#[available_gas(25000000)]
fn test_initializer() {
    let (world, mut state) = STATE();
    // InternalImpl::initializer(ref state, NAME, SYMBOL);
    state.initialize(NAME, SYMBOL,world.contract_address);
    assert(ERC20Impl::name(@state) == NAME, 'Name should be NAME');
    assert(ERC20Impl::symbol(@state) == SYMBOL, 'Symbol should be SYMBOL');
    assert(ERC20Impl::decimals(@state) == DECIMALS, 'Decimals should be 18');
}

// //
// // Getters
// //

#[test]
#[available_gas(25000000)]
fn test_total_supply() {
    let (world, mut state) = setup();
    state.mint_(OWNER(), SUPPLY);
    // InternalImpl::_mint(ref state, OWNER(), SUPPLY);
    assert(ERC20Impl::total_supply(@state) == SUPPLY, 'Should eq SUPPLY');
}

#[test]
#[available_gas(25000000)]
fn test_balance_of() {
    let (world, mut state) = setup();
    InternalImpl::_mint(ref state, OWNER(), SUPPLY);
    assert(ERC20Impl::balance_of(@state, OWNER()) == SUPPLY, 'Should eq SUPPLY');
}


#[test]
#[available_gas(25000000)]
fn test_allowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE, 'Should eq VALUE');
}

// // //
// // // approve & _approve
// // //

#[test]
#[available_gas(25000000)]
fn test_approve() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    assert(ERC20Impl::approve(ref state, SPENDER(), VALUE), 'Should return true');
    assert(
        ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE, 'Spender not approved correctly'
    );
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve from 0',))]
fn test_approve_from_zero() {
    let (world, mut state) = setup();
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve to 0',))]
fn test_approve_to_zero() {
        let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
fn test__approve() {
        let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    state.approve(SPENDER(), VALUE);
    // InternalImpl::_approve(ref state, OWNER(), SPENDER(), VALUE);
    assert(
        ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE, 'Spender not approved correctly'
    );
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve from 0',))]
fn test__approve_from_zero() {
    let (world, mut state) = setup();
    InternalImpl::_approve(ref state, Zeroable::zero(), SPENDER(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve to 0',))]
fn test__approve_to_zero() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    InternalImpl::_approve(ref state, OWNER(), Zeroable::zero(), VALUE);
}

// //
// // transfer & _transfer
// //

#[test]
#[available_gas(25000000)]
fn test_transfer() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    state.mint_(OWNER(), SUPPLY);
    assert(ERC20Impl::transfer(ref state, RECIPIENT(), VALUE), 'Should return true');
    // assert_only_event_transfer(OWNER(), RECIPIENT(), VALUE);
    assert(ERC20Impl::balance_of(@state, RECIPIENT()) == VALUE, 'Balance should eq VALUE');
    assert(ERC20Impl::balance_of(@state, OWNER()) == SUPPLY - VALUE, 'Should eq supply - VALUE');
    assert(ERC20Impl::total_supply(@state) == SUPPLY, 'Total supply should not change');
}

#[test]
#[available_gas(25000000)]
fn test__transfer() {
    let (world, mut state) = setup();
    state.mint_(OWNER(), SUPPLY);
    InternalImpl::_transfer(ref state, OWNER(), RECIPIENT(), VALUE);
    // assert_only_event_transfer(OWNER(), RECIPIENT(), VALUE);
    assert(ERC20Impl::balance_of(@state, RECIPIENT()) == VALUE, 'Balance should eq amount');
    assert(ERC20Impl::balance_of(@state, OWNER()) == SUPPLY - VALUE, 'Should eq supply - amount');
    assert(ERC20Impl::total_supply(@state) == SUPPLY, 'Total supply should not change');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test__transfer_not_enough_balance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());

    let balance_plus_one = SUPPLY + 1;
    InternalImpl::_transfer(ref state, OWNER(), RECIPIENT(), balance_plus_one);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: transfer from 0',))]
fn test__transfer_from_zero() {
    let (world, mut state) = setup();
    InternalImpl::_transfer(ref state, Zeroable::zero(), RECIPIENT(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: transfer to 0',))]
fn test__transfer_to_zero() {
    let (world, mut state) = setup();
    InternalImpl::_transfer(ref state, OWNER(), Zeroable::zero(), VALUE);
}

// //
// // transfer_from
// //

#[test]
#[available_gas(30000000)]
fn test_transfer_from() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    state.mint_(OWNER(), SUPPLY);
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    utils::drop_event(ZERO());

    testing::set_caller_address(SPENDER());
    assert(ERC20Impl::transfer_from(ref state, OWNER(), RECIPIENT(), VALUE), 'Should return true');

    // assert_event_approval(OWNER(), SPENDER(), 0);
    // assert_only_event_transfer(OWNER(), RECIPIENT(), VALUE);

    assert(ERC20Impl::balance_of(@state, RECIPIENT()) == VALUE, 'Should eq amount');
    assert(ERC20Impl::balance_of(@state, OWNER()) == SUPPLY - VALUE, 'Should eq suppy - amount');
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == 0, 'Should eq 0');
    assert(ERC20Impl::total_supply(@state) == SUPPLY, 'Total supply should not change');
}


#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_transfer_from_greater_than_allowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);

    testing::set_caller_address(SPENDER());
    let allowance_plus_one = VALUE + 1;
    ERC20Impl::transfer_from(ref state, OWNER(), RECIPIENT(), allowance_plus_one);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: transfer to 0',))]
fn test_transfer_from_to_zero_address() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);

    testing::set_caller_address(SPENDER());
    ERC20Impl::transfer_from(ref state, OWNER(), Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_transfer_from_from_zero_address() {
    let (world, mut state) = setup();
    ERC20Impl::transfer_from(ref state, Zeroable::zero(), RECIPIENT(), VALUE);
}

// //
// // increase_allowance & increaseAllowance
// //

#[test]
#[available_gas(25000000)]
fn test_increase_allowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    utils::drop_event(ZERO());

    assert(erc_systems::increase_allowance(ref state, SPENDER(), VALUE), 'Should return true');

    // assert_only_event_approval(OWNER(), SPENDER(), VALUE * 2);
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE * 2, 'Should be amount * 2');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve to 0',))]
fn test_increase_allowance_to_zero_address() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    erc_systems::increase_allowance(ref state, Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve from 0',))]
fn test_increase_allowance_from_zero_address() {
    let (world, mut state) = setup();
    erc_systems::increase_allowance(ref state, SPENDER(), VALUE);
}

#[test]
#[available_gas(25000000)]
fn test_increaseAllowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    utils::drop_event(ZERO());

    assert(erc_systems::increaseAllowance(ref state, SPENDER(), VALUE), 'Should return true');

    // assert_only_event_approval(OWNER(), SPENDER(), 2 * VALUE);
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE * 2, 'Should be amount * 2');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve to 0',))]
fn test_increaseAllowance_to_zero_address() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    erc_systems::increaseAllowance(ref state, Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: approve from 0',))]
fn test_increaseAllowance_from_zero_address() {
    let (world, mut state) = setup();
    erc_systems::increaseAllowance(ref state, SPENDER(), VALUE);
}

// //
// // decrease_allowance & decreaseAllowance
// //

#[test]
#[available_gas(25000000)]
fn test_decrease_allowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    utils::drop_event(ZERO());

    assert(erc_systems::decrease_allowance(ref state, SPENDER(), VALUE), 'Should return true');

    // assert_only_event_approval(OWNER(), SPENDER(), 0);
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE - VALUE, 'Should be 0');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_decrease_allowance_to_zero_address() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    erc_systems::decrease_allowance(ref state, Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_decrease_allowance_from_zero_address() {
    let (world, mut state) = setup();
    erc_systems::decrease_allowance(ref state, SPENDER(), VALUE);
}

#[test]
#[available_gas(25000000)]
fn test_decreaseAllowance() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    ERC20Impl::approve(ref state, SPENDER(), VALUE);
    utils::drop_event(ZERO());

    assert(erc_systems::decreaseAllowance(ref state, SPENDER(), VALUE), 'Should return true');

    // assert_only_event_approval(OWNER(), SPENDER(), 0);
    assert(ERC20Impl::allowance(@state, OWNER(), SPENDER()) == VALUE - VALUE, 'Should be 0');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_decreaseAllowance_to_zero_address() {
    let (world, mut state) = setup();
    testing::set_caller_address(OWNER());
    erc_systems::decreaseAllowance(ref state, Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('u256_sub Overflow',))]
fn test_decreaseAllowance_from_zero_address() {
    let (world, mut state) = setup();
    erc_systems::decreaseAllowance(ref state, SPENDER(), VALUE);
}

// //
// // _spend_allowance
// //

#[test]
#[available_gas(25000000)]
fn test__spend_allowance_not_unlimited() {
    let (world, mut state) = setup();

    InternalImpl::_approve(ref state, OWNER(), SPENDER(), SUPPLY);
    utils::drop_event(ZERO());

    InternalImpl::_spend_allowance(ref state, OWNER(), SPENDER(), VALUE);

    // assert_only_event_approval(OWNER(), SPENDER(), SUPPLY - VALUE);
    assert(
        ERC20Impl::allowance(@state, OWNER(), SPENDER()) == SUPPLY - VALUE,
        'Should eq supply - amount'
    );
}

#[test]
#[available_gas(25000000)]
fn test__spend_allowance_unlimited() {
    let (world, mut state) = setup();
    InternalImpl::_approve(ref state, OWNER(), SPENDER(), BoundedInt::max());

    let max_minus_one: u256 = BoundedInt::max() - 1;
    InternalImpl::_spend_allowance(ref state, OWNER(), SPENDER(), max_minus_one);

    assert(
        ERC20Impl::allowance(@state, OWNER(), SPENDER()) == BoundedInt::max(),
        'Allowance should not change'
    );
}

// //
// // _mint
// //

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: mint to 0',))]
fn test__mint_to_zero() {
    let (world, mut state) = setup();
    InternalImpl::_mint(ref state, Zeroable::zero(), VALUE);
}

// //
// // _burn
// //

#[test]
#[available_gas(25000000)]
fn test__burn() {
    let (world, mut state) = setup();
    state.mint_(OWNER(), SUPPLY);
    InternalImpl::_burn(ref state, OWNER(), VALUE);

    // assert_only_event_transfer(OWNER(), ZERO(), VALUE);
    assert(ERC20Impl::total_supply(@state) == SUPPLY - VALUE, 'Should eq supply - amount');
    assert(ERC20Impl::balance_of(@state, OWNER()) == SUPPLY - VALUE, 'Should eq supply - amount');
}

#[test]
#[available_gas(25000000)]
#[should_panic(expected: ('ERC20: burn from 0',))]
fn test__burn_from_zero() {
    let (world, mut state) = setup();
    InternalImpl::_burn(ref state, Zeroable::zero(), VALUE);
}

// //
// // Helpers
// //

// fn assert_event_approval(owner: ContractAddress, spender: ContractAddress, value: u256) {
//     let event = utils::pop_log::<Approval>(ZERO()).unwrap();
//     assert(event.owner == owner, 'Invalid `owner`');
//     assert(event.spender == spender, 'Invalid `spender`');
//     assert(event.value == value, 'Invalid `value`');
// }

// fn assert_only_event_approval(owner: ContractAddress, spender: ContractAddress, value: u256) {
//     assert_event_approval(owner, spender, value);
//     utils::assert_no_events_left(ZERO());
// }

// fn assert_event_transfer(from: ContractAddress, to: ContractAddress, value: u256) {
//     let event = utils::pop_log::<Transfer>(ZERO()).unwrap();
//     assert(event.from == from, 'Invalid `from`');
//     assert(event.to == to, 'Invalid `to`');
//     assert(event.value == value, 'Invalid `value`');
// }

// fn assert_only_event_transfer(from: ContractAddress, to: ContractAddress, value: u256) {
//     assert_event_transfer(from, to, value);
//     utils::assert_no_events_left(ZERO());
// }

}