#[cfg(test)]
mod actions_test {
    use debug::PrintTrait;
    use serde::Serde;
    use starknet::SyscallResultTrait;
    use starknet::{class_hash::Felt252TryIntoClassHash,contract_address_const, get_contract_address, ContractAddress};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // import models
    use l2::the_marquis::models::{game, move};
    use l2::the_marquis::models::{Game, Choice, Move};

    // import actions
    use l2::the_marquis::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    use l2::the_marquis::utils::{seed, random};


    // reusable function for tests
    fn setup_world() -> (IWorldDispatcher, IActionsDispatcher, ContractAddress) {
        // models
        let mut models = array![game::TEST_CLASS_HASH, move::TEST_CLASS_HASH];
        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let actions_system = IActionsDispatcher { contract_address };

        // deploy erc20 contract
        let erc20_address = world.deploy_contract('salt', move::TEST_CLASS_HASH.try_into().unwrap());

        // mint tokens to actions contract
        _mint(erc20_address, contract_address, 100000);

        // mint tokens to this contract
        _mint(erc20_address, get_contract_address(), 100000);

        // initialize the token

        (world, actions_system, erc20_address)
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_many_moves_and_win() {
        // set player address
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();
        let playerC = contract_address_const::<0x3>();


        let (world, actions_system, erc20_address) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn();

        // create array of choices for playerA
        let playerA_choice_array = array![
            Choice::OneRed(()),
            Choice::ThreeRed(()),
            Choice::Odd(()),
            Choice::ThirteenToTwentyFour(()),
        ];

        // create array of amounts for playerA
        let playerA_amount_array = array![10, 20, 30, 40];

        // create array of choices for playerB
        let playerB_choice_array = array![
            Choice::TwoBlack(()),
            Choice::FourBlack(()),
            Choice::Even(()),
            Choice::OneToTwelve(()),
        ];

        // create array of amounts for playerB
        let playerB_amount_array = array![50, 60, 70, 80];

        // create array of choices for playerC
        let playerC_choice_array = array![
            Choice::Odd(()),
            Choice::OneToEighteen(()),
        ];

        // create array of amounts for playerC
        let playerC_amount_array = array![20, 30];

        // test playerA move

        // approve tokens before move

        actions_system.move(game_id, playerA_choice_array, playerA_amount_array);
        actions_system.move(game_id, playerB_choice_array, playerB_amount_array);
        actions_system.move(game_id, playerC_choice_array, playerC_amount_array);

        // check move count
        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 10, 'Move count is wrong');

        // set winner
        let winning_number = 7;
        actions_system.set_winner(game_id, winning_number);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 0, 'Move count is wrong');

        // 60 + 240 + 100
        assert(curr_game.last_total_paid == 400, 'Total paid is wrong');


    }
    fn _approve(_token_address : ContractAddress, _to: ContractAddress, _amount: u32) -> bool{
        let mut call_data: Array<felt252> = ArrayTrait::new();
        Serde::serialize(@_to, ref call_data);
        Serde::serialize(@_amount, ref call_data);
        Serde::serialize(@0, ref call_data); // uint256 passed as (_amount, 0)
        let mut res = starknet::call_contract_syscall(
            _token_address, selector!("approve"), call_data.span()
        )
            .unwrap_syscall();
        Serde::<bool>::deserialize(ref res).unwrap()
    }
    fn _mint(_token_address : ContractAddress, _to: ContractAddress, _amount: u32) -> bool{
        let mut call_data: Array<felt252> = ArrayTrait::new();
        Serde::serialize(@_to, ref call_data);
        Serde::serialize(@_amount, ref call_data);
        Serde::serialize(@0, ref call_data); // uint256 passed as (_amount, 0)
        let mut res = starknet::call_contract_syscall(
            _token_address, selector!("mint_"), call_data.span()
        )
            .unwrap_syscall();
        Serde::<bool>::deserialize(ref res).unwrap()
    }
    fn _initalize(_token_address : ContractAddress, name: felt252, symbol: felt252, world: ContractAddress) -> bool{
        let mut call_data: Array<felt252> = ArrayTrait::new();
        Serde::serialize(@name, ref call_data);
        Serde::serialize(@symbol, ref call_data);
        Serde::serialize(@world, ref call_data);
        let mut res = starknet::call_contract_syscall(
            _token_address, selector!("initialize"), call_data.span()
        )
            .unwrap_syscall();
        Serde::<bool>::deserialize(ref res).unwrap()
    }
}