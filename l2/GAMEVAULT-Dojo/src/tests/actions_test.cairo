#[cfg(test)]
mod actions_test {
    use debug::PrintTrait;

    use starknet::{class_hash::Felt252TryIntoClassHash,contract_address_const};

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
    fn setup_world() -> (IWorldDispatcher, IActionsDispatcher) {
        // models
        let mut models = array![game::TEST_CLASS_HASH, move::TEST_CLASS_HASH];
        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let actions_system = IActionsDispatcher { contract_address };

        (world, actions_system)
    }
    #[test]
    #[available_gas(30000000)]
    fn test_spawn() {
        // players
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();
        let (world, actions_system) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn();
        let game = get!(world, game_id, (Game));
        assert(game.move_count == 0, 'move_count should be zero');
        assert(game.last_total_paid == 0, 'Total paid should be zero');
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_many_moves_and_win() {
        // set player address
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();
        let playerC = contract_address_const::<0x3>();


        let (world, actions_system) = setup_world();

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
        // call move with OneRed choice

        actions_system.move(game_id, playerA, playerA_choice_array, playerA_amount_array);
        actions_system.move(game_id, playerB, playerB_choice_array, playerB_amount_array);
        actions_system.move(game_id, playerC, playerC_choice_array, playerC_amount_array);

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
}