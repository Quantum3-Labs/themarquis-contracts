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
    fn test_move() {
        // set player address
        let playerA = contract_address_const::<0x1>();

        let (world, actions_system) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn();

        // turn for playerA, prepare choices
        let pA_choice = Choice::OneRed(());
        let pA_amount = 10;

        // test playerA move
        // call move with OneRed choice
        actions_system.move(game_id, playerA, pA_choice, pA_amount);

        let curr_game = get!(world, (game_id), Game);

        assert(curr_game.move_count == 1, 'Move count is wrong');
        let move_id = curr_game.move_count;
        let curr_move = get!(world, (game_id, move_id), Move);

        // check playerA choice
        assert(curr_move.choice == pA_choice, 'choice is wrong');
        assert(curr_move.amount == pA_amount, 'amount is wrong');
     }

    #[test]
    #[available_gas(3000000000)]
    fn test_fixed_winners() {
        // initialize game and spawn 
        let (world, actions_system) = setup_world();
        let game_id = actions_system.spawn();

        // choose random number of players
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();
        let playerC = contract_address_const::<0x3>();
        let playerD = contract_address_const::<0x4>();

        // playerB moves
        actions_system.move(game_id, playerB, Choice::OneRed(()), 70);
        // playerA moves
        actions_system.move(game_id, playerA, Choice::ThreeRed(()), 30);
        // playerC moves
        actions_system.move(game_id, playerC, Choice::ThirtyFiveRed(()), 20);
        // player B moves again
        actions_system.move(game_id, playerB, Choice::Odd(()), 50);

        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 4, 'Move count is wrong');

        // check data of each move
        let move1_id = 1;
        let move1 = get!(world, (game_id, move1_id), Move);
        assert(move1.player == playerB, 'Player is wrong');
        assert(move1.choice.into() == 1, 'Choice is wrong');
        assert(move1.amount == 70, 'Amount is wrong');

        let move2_id = 2;
        let move2 = get!(world, (game_id, move2_id), Move);
        assert(move2.player == playerA, 'Player is wrong');
        assert(move2.choice.into() == 3, 'Choice is wrong');
        assert(move2.amount == 30, 'Amount is wrong');

        let move3_id = 3;
        let move3 = get!(world, (game_id, move3_id), Move);
        assert(move3.player == playerC, 'Player is wrong');
        assert(move3.choice.into() == 35, 'Choice is wrong');
        assert(move3.amount == 20, 'Amount is wrong');

        let move4_id = 4;
        let move4 = get!(world, (game_id, move4_id), Move);
        assert(move4.player == playerB, 'Player is wrong');
        assert(move4.choice.into() == 47, 'Choice is wrong');
        assert(move4.amount == 50, 'Amount is wrong');

        // set winner
        let fixed_winning_number = 1;
        actions_system.set_winner(game_id, fixed_winning_number);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game); 
        
        // 31 * 70 + 50 * 2 = 2270
        assert(curr_game.last_total_paid == 2270, 'Total paid is wrong');

        // play again -- WE DONT NEED SPAWN AGAIN

        // playerA moves
        actions_system.move(game_id, playerA, Choice::OneRed(()), 70);
        // playerB moves
        actions_system.move(game_id, playerB, Choice::TwoBlack(()), 20);
        // playerC moves
        actions_system.move(game_id, playerC, Choice::EighteenBlack(()), 30);
        // playerD moves
        actions_system.move(game_id, playerD, Choice::OneToTwelve(()), 40);
        // player A moves again
        actions_system.move(game_id, playerA, Choice::Even(()), 50);
        // player C moves again
        actions_system.move(game_id, playerC, Choice::OneRed(()), 70);
        // player C moves again
        actions_system.move(game_id, playerC, Choice::TwoBlack(()), 20);
        // player D moves again
        actions_system.move(game_id, playerD, Choice::ThreeRed(()), 30);

        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 8, 'Move count is wrong');

        // check data of some random moves
        let move1 = get!(world, (game_id, 1), Move);
        assert(move1.player == playerA, 'Player is wrong');
        assert(move1.choice.into() == 1, 'Choice is wrong');
        assert(move1.amount == 70, 'Amount is wrong');

        let move2 = get!(world, (game_id, 2), Move);
        assert(move2.player == playerB, 'Player is wrong');
        assert(move2.choice.into() == 2, 'Choice is wrong');
        assert(move2.amount == 20, 'Amount is wrong');

        let move3 = get!(world, (game_id, 3), Move);
        assert(move3.player == playerC, 'Player is wrong');
        assert(move3.choice.into() == 18, 'Choice is wrong');
        assert(move3.amount == 30, 'Amount is wrong');

        // set winner
        actions_system.set_winner(game_id, 7);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game);
        // 40*3=120
        assert(curr_game.last_total_paid == 120, 'Total paid is wrong');

     }
     
    // #[test]
    // #[available_gas(30000000)]
    // #[ignore]
    // fn test_random() {
    //      // players
    //     let playerA = contract_address_const::<0x1>();
    //     let playerB = contract_address_const::<0x2>();

    //     let (world, actions_system) = setup_world();

    //     // call spawn()
    //     let game_id = actions_system.spawn(playerA, playerB);

    //    // turn for playerA, prepare choices
    //     let pA_choice1 = Choice::OneRed(());
    //     let pA_amount1 = 10;
    //     let pA_choice2 = Choice::FourBlack(());
    //     let pA_amount2 = 50;

    //     // test playerA move
    //     // call move with OneRed and FourBlack choice
    //     actions_system.move(game_id, playerA, pA_choice1, pA_amount1, pA_choice2, pA_amount2);

    //     let game_turnA = get!(world, (game_id, playerA), GameTurn);

    //     // turn for playerB
    //     let pB_choice1 = Choice::TwoBlack(());
    //     let pB_amount1 = 20;
    //     let pB_choice2 = Choice::ThreeRed(());
    //     let pB_amount2 = 30;

    //     // test playerB move
    //     // call move with TwoBlack and ThreeRed choice
    //     actions_system.move(game_id, playerB, pB_choice1, pB_amount1, pB_choice2, pB_amount2);

    //     let game_turnB = get!(world, (game_id, playerB), GameTurn);
        
    //     // dummy vrf winning_number, FIXME
    //     let winning_number = random(pedersen::pedersen(seed(), pB_choice2.into()), 48);
    //     winning_number.print(); // Beacuse of seed() setup, this winning_number value is 3, then it is mapped into Choice::ThreeRed(())

    //     actions_system.set_winner(game_id, winning_number);

    //     let game = get!(world, game_id, Game);
    //     // dummy assert, we know pB_choice2 = Choice::ThreeRed(()), so playerB wins
    //     assert(game.winner == playerB, 'Wrgong winner');
    //     game.winner.print();  // Because of seed (), player wins
    // }
}