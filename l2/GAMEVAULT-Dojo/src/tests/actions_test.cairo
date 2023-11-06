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
    use l2::the_marquis::models::{Game,PlayerChoice, Choice, Move};

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
    fn test_one_move_two_choices() {
        // set player address
        let playerA = contract_address_const::<0x1>();

        let (world, actions_system) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn();

        // turn for playerA, prepare move
        let move_id = actions_system.move(game_id, playerA);

        // prepare choice 1
        let pA_choice = Choice::OneRed(());
        let pA_amount = 10;
        let choice_id = actions_system.choice(game_id, move_id, pA_choice, pA_amount);

        // call move with OneRed choice

        // check game data
        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 1, 'Move count is wrong');

        // check playerA Move
        let curr_move = get!(world, (game_id, move_id), Move);
        assert(curr_move.player == playerA, 'Player address is wrong');
        assert(curr_move.choice_count == 1, 'Choice count is wrong');

        // check playerA choice
        let curr_choice = get!(world, (game_id, move_id, choice_id), PlayerChoice);
        assert(curr_choice.choice == pA_choice, 'Choice is wrong');
        assert(curr_choice.amount == pA_amount, 'Amount is wrong');

        // prepare choice 2
        let pA_choice2 = Choice::TwoBlack(());
        let pA_amount2 = 20;
        let choice2_id = actions_system.choice(game_id, move_id, pA_choice2, pA_amount2);

        // call move with OneRed choice

        // check game data
        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 1, 'Move count is wrong');

        // check playerA Move
        let curr_move = get!(world, (game_id, move_id), Move);
        assert(curr_move.player == playerA, 'Player address is wrong');
        assert(curr_move.choice_count == 2, 'Choice count is wrong');

        // check playerA choice
        let curr_choice = get!(world, (game_id, move_id, choice2_id), PlayerChoice);
        assert(curr_choice.choice == pA_choice2, 'Choice2 is wrong');
        assert(curr_choice.amount == pA_amount2, 'Amount2 is wrong');
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

        // set 3 moves and 4 choices
        // playerB moves and chooses 
        let move1_id = actions_system.move(game_id, playerB);
        let m1_choice1_id = actions_system.choice(game_id, move1_id, Choice::OneRed(()), 70);
        // playerA moves and chooses 
        let move2_id = actions_system.move(game_id, playerA);
        let choice2_id = actions_system.choice(game_id, move2_id, Choice::ThreeRed(()), 30);
        // playerC moves and chooses 
        let move3_id = actions_system.move(game_id, playerC);
        let choice3_id = actions_system.choice(game_id, move3_id, Choice::ThirtyFiveRed(()), 20);
        // playerB chooses again
        let m1_choice2_id = actions_system.choice(game_id, move1_id, Choice::Odd(()), 50);

        // check game data
        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 3, 'Move count is wrong');

        // check playerB Move
        let move1 = get!(world, (game_id, move1_id), Move);
        assert(move1.player == playerB, 'Player is wrong');
        assert(move1.choice_count == 2, 'Choice count is wrong');

        // check playerB choice
        let m1_choice1 = get!(world, (game_id, move1_id, m1_choice1_id), PlayerChoice);
        assert(m1_choice1.choice.into() == 1, 'Choice1 is wrong');
        assert(m1_choice1.amount == 70, 'Amount1 is wrong');

        // check playerA Move
        let move2 = get!(world, (game_id, move2_id), Move);
        assert(move2.player == playerA, 'Player is wrong');
        assert(move2.choice_count == 1, 'Choice count is wrong');

        // check playerA choice
        let choice2_id = move2.choice_count;
        let choice2 = get!(world, (game_id, move2_id, choice2_id), PlayerChoice);
        assert(choice2.choice.into() == 3, 'Choice2 is wrong');
        assert(choice2.amount == 30, 'Amount2 is wrong');

        // check playerC Move
        let move3 = get!(world, (game_id, move3_id), Move);
        assert(move3.player == playerC, 'Player is wrong');
        assert(move3.choice_count == 1, 'Choice count is wrong');

        // check playerC choice
        let choice3_id = move3.choice_count;
        let choice3 = get!(world, (game_id, move3_id, choice3_id), PlayerChoice);
        assert(choice3.choice.into() == 35, 'Choice3 is wrong');
        assert(choice3.amount == 20, 'Amount is wrong');


        // check playerB 2nd Choice
        let m1_choice2 = get!(world, (game_id, move1_id, m1_choice2_id), PlayerChoice);
        assert(m1_choice2.choice.into() == 47, 'Choice4 is wrong');
        assert(m1_choice2.amount == 50, 'Amount is wrong');

        // set winner
        let fixed_winning_number = 1;
        actions_system.set_winner(game_id, fixed_winning_number);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game); 
        
        // 31 * 70 + 50 * 2 = 2270
        assert(curr_game.last_total_paid == 2270, 'Total paid is wrong');

        // play again -- WE DONT NEED SPAWN AGAIN

        let playerD = contract_address_const::<0x4>();

        // playerA moves and chooses
        let moveA_id = actions_system.move(game_id, playerA);
        let choiceA_id = actions_system.choice(game_id, moveA_id, Choice::OneRed(()), 70);
        // playerB moves and chooses
        let moveB_id = actions_system.move(game_id, playerB);
        let choiceB_id = actions_system.choice(game_id, moveB_id, Choice::TwoBlack(()), 20);
        // playerC moves and chooses
        let moveC_id = actions_system.move(game_id, playerC);
        let choiceC_id = actions_system.choice(game_id, moveC_id, Choice::EighteenBlack(()), 30);
        // playerD moves and chooses
        let moveD_id = actions_system.move(game_id, playerD);
        let choiceD_id = actions_system.choice(game_id, moveD_id, Choice::OneToTwelve(()), 40);
        // player A chooses again
        let choiceA_2_id = actions_system.choice(game_id, moveA_id, Choice::Even(()), 50);
        // player C chooses again
        let choiceC_2_id = actions_system.choice(game_id, moveC_id, Choice::OneRed(()), 70);
        // player C chooses again
        let choiceC_3_id = actions_system.choice(game_id, moveC_id, Choice::TwoBlack(()), 20);
        // player D moves again
        let choiceD_2_id = actions_system.choice(game_id, moveD_id, Choice::ThreeRed(()), 30);

        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 4, 'Move count is wrong');

        // check data of some random moves
        let move1 = get!(world, (game_id, moveA_id), Move);
        assert(move1.player == playerA, 'Player is wrong');
        assert(move1.choice_count == 2, 'Choice count is wrong');

        // assert(move1.choice.into() == 1, 'Choice is wrong');
        // assert(move1.amount == 70, 'Amount is wrong');

        // let move2 = get!(world, (game_id, 2), Move);
        // assert(move2.player == playerB, 'Player is wrong');
        // assert(move2.choice.into() == 2, 'Choice is wrong');
        // assert(move2.amount == 20, 'Amount is wrong');

        // let move3 = get!(world, (game_id, 3), Move);
        // assert(move3.player == playerC, 'Player is wrong');
        // assert(move3.choice.into() == 18, 'Choice is wrong');
        // assert(move3.amount == 30, 'Amount is wrong');

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