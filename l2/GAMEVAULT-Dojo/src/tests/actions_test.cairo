#[cfg(test)]
mod tests {
    use debug::PrintTrait;

    use starknet::{class_hash::Felt252TryIntoClassHash, contract_address_const};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // import models
    use l2::the_marquis::models::{game, game_turn};
    use l2::the_marquis::models::{Game, GameTurn, Choice, Move};

    // import actions
    use l2::the_marquis::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    use l2::the_marquis::utils::{seed, random};


    // reusable function for tests
    fn setup_world() -> (IWorldDispatcher, IActionsDispatcher) {
        // models
        let mut models = array![game::TEST_CLASS_HASH, game_turn::TEST_CLASS_HASH];
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
        let game_id = actions_system.spawn(playerA, playerB);
        let game = get!(world, game_id, (Game));
        assert(game.playerA == contract_address_const::<0x1>(), 'playerA address is wrong');
        assert(game.playerB == contract_address_const::<0x2>(), 'playerB address is wrong');

        // test setup of playerA
        let game_turn = get!(world, (game_id, playerA), (GameTurn));
        assert(game_turn.game_id == game_id, 'game_id is wrong');
        assert(game_turn.player == game.playerA, 'player is wrong');
        assert(game_turn.choice1 == Choice::None(()), 'choice is wrong');
        assert(game_turn.amount1 == 0, 'amount is wrong');

        // test setup of playerB
        let game_turn = get!(world, (game_id, playerB), (GameTurn));
        assert(game_turn.game_id == game_id, 'game_id is wrong');
        assert(game_turn.player == game.playerB, 'player is wrong');
        assert(game_turn.choice1 == Choice::None(()), 'choice is wrong');
        assert(game_turn.amount1 == 0, 'amount is wrong');
    }
    #[test]
    #[available_gas(3000000000)]
    fn test_move() {
        // players
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();

        let (world, actions_system) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn(playerA, playerB);

        // turn for playerA, prepare choices
        let pA_choice1 = Choice::OneRed(());
        let pA_amount1 = 10;

        let pA_choice2 = Choice::FourBlack(());
        let pA_amount2 = 40;

        // test playerA move
        // call move with OneRed and FourBlack choice
        actions_system.move(game_id, playerA, pA_choice1, pA_amount1, pA_choice2, pA_amount2);

        let game_turnA = get!(world, (game_id, playerA), GameTurn);

        // casting choices
        let one_red_felt: felt252 = pA_choice1.into();
        let eight_black_felt: felt252 = pA_choice2.into();

        // check playerA choice1
        assert(game_turnA.choice1.into() == one_red_felt, 'choice is wrong');
        assert(game_turnA.amount1 == pA_amount1, 'amount is wrong');

        // check playerA choice2
        assert(game_turnA.choice2.into() == eight_black_felt, 'choice is wrong');
        assert(game_turnA.amount2 == pA_amount2, 'amount is wrong');

        // turn for playerB
        let pB_choice1 = Choice::TwoBlack(());
        let pB_amount1 = 20;

        let pB_choice2 = Choice::ThreeRed(());
        let pB_amount2 = 30;

        // test playerB move
        // call move with TwoBlack and ThreeRed choice
        actions_system.move(game_id, playerB, pB_choice1, pB_amount1, pB_choice2, pB_amount2);

        let game_turnB = get!(world, (game_id, playerB), GameTurn);

        // casting choices
        let two_black_felt: felt252 = pB_choice1.into();
        let three_red_felt: felt252 = pB_choice2.into();

        // check playerB choice1
        assert(game_turnB.choice1.into() == two_black_felt, 'choice is wrong');
        assert(game_turnB.amount1 == pB_amount1, 'amount is wrong');

        // check playerB choice2
        assert(game_turnB.choice2.into() == three_red_felt, 'choice is wrong');
        assert(game_turnB.amount2 == pB_amount2, 'amount is wrong');
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_fixed_winners() {
        // players
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();

        let (world, actions_system) = setup_world();

        // call spawn()
        let game_id = actions_system.spawn(playerA, playerB);

        // turn for playerA, prepare choices
        let pA_choice1 = Choice::OneRed(());
        let pA_amount1 = 10;
        let pA_choice2 = Choice::FourBlack(());
        let pA_amount2 = 120;

        // test playerA move
        // call move with OneRed and OneToTwelve choice
        actions_system.move(game_id, playerA, pA_choice1, pA_amount1, pA_choice2, pA_amount2);

        let game_turnA = get!(world, (game_id, playerA), GameTurn);

        // turn for playerB
        let pB_choice1 = Choice::Even(());
        let pB_amount1 = 20;
        let pB_choice2 = Choice::ThreeRed(());
        let pB_amount2 = 30;

        // test playerB move
        // call move with TwoBlack and ThreeRed choice
        actions_system.move(game_id, playerB, pB_choice1, pB_amount1, pB_choice2, pB_amount2);

        let game_turnB = get!(world, (game_id, playerB), GameTurn);

        let fixed_winning_number = 4;

        actions_system.set_winner(game_id, fixed_winning_number);

        let game = get!(world, game_id, (Game));
        assert(
            game.playerA_earned_amount == 3720, 'PlayerA earned amount is wrong'
        ); //31*120=3720  
        assert(game.playerB_earned_amount == 40, 'PlayerB earned amount is wrong'); // 20*2=40
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_v2() {
        // initialize game and spawn 
        let (world, actions_system) = setup_world();
        let game_id = actions_system.spawn_v2();

        // choose random number of players
        let playerA = contract_address_const::<0x1>();
        let playerB = contract_address_const::<0x2>();
        let playerC = contract_address_const::<0x3>();
        let playerD = contract_address_const::<0x4>();

        // playerB moves
        actions_system.move_v2(game_id, playerB, Choice::OneRed(()), 70);
        // playerC moves
        actions_system.move_v2(game_id, playerC, Choice::TwoBlack(()), 20);
        // playerA moves
        actions_system.move_v2(game_id, playerA, Choice::ThreeRed(()), 30);
        // playerD moves
        actions_system.move_v2(game_id, playerD, Choice::FourBlack(()), 40);
        // player B moves again
        actions_system.move_v2(game_id, playerB, Choice::Even(()), 50);

        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 5, 'Move count is wrong');

        // check data of each move
        let curr_move = get!(world, (game_id, 0), Move);
        assert(curr_move.player == playerB, 'Player is wrong');
        assert(curr_move.choice.into() == 1, 'Choice is wrong');
        assert(curr_move.amount == 70, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 1), Move);
        assert(curr_move.player == playerC, 'Player is wrong');
        assert(curr_move.choice.into() == 2, 'Choice is wrong');
        assert(curr_move.amount == 20, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 2), Move);
        assert(curr_move.player == playerA, 'Player is wrong');
        assert(curr_move.choice.into() == 3, 'Choice is wrong');
        assert(curr_move.amount == 30, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 3), Move);
        assert(curr_move.player == playerD, 'Player is wrong');
        assert(curr_move.choice.into() == 4, 'Choice is wrong');
        assert(curr_move.amount == 40, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 4), Move);
        assert(curr_move.player == playerB, 'Player is wrong');
        assert(curr_move.choice.into() == 46, 'Choice is wrong');
        assert(curr_move.amount == 50, 'Amount is wrong');

        // set winner
        actions_system.set_winner_v2(game_id, 4);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game);

        // 31 * 40 + 50 * 2 = 1320
        assert(curr_game.last_total_paid == 1340, 'Total paid is wrong');

        // play again -- WE DONT NEED SPAWN AGAIN

        // playerA moves
        actions_system.move_v2(game_id, playerA, Choice::OneRed(()), 70);
        // playerB moves
        actions_system.move_v2(game_id, playerB, Choice::TwoBlack(()), 20);
        // playerC moves
        actions_system.move_v2(game_id, playerC, Choice::EighteenBlack(()), 30);
        // playerD moves
        actions_system.move_v2(game_id, playerD, Choice::OneToTwelve(()), 40);
        // player A moves again
        actions_system.move_v2(game_id, playerA, Choice::Even(()), 50);
        // player C moves again
        actions_system.move_v2(game_id, playerC, Choice::OneRed(()), 70);
        // player C moves again
        actions_system.move_v2(game_id, playerC, Choice::TwoBlack(()), 20);
        // player D moves again
        actions_system.move_v2(game_id, playerD, Choice::ThreeRed(()), 30);

        let curr_game = get!(world, (game_id), Game);
        assert(curr_game.move_count == 8, 'Move count is wrong');

        // check data of some random moves
        let curr_move = get!(world, (game_id, 0), Move);
        assert(curr_move.player == playerA, 'Player is wrong');
        assert(curr_move.choice.into() == 1, 'Choice is wrong');
        assert(curr_move.amount == 70, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 1), Move);
        assert(curr_move.player == playerB, 'Player is wrong');
        assert(curr_move.choice.into() == 2, 'Choice is wrong');
        assert(curr_move.amount == 20, 'Amount is wrong');

        let curr_move = get!(world, (game_id, 2), Move);
        assert(curr_move.player == playerC, 'Player is wrong');
        assert(curr_move.choice.into() == 18, 'Choice is wrong');
        assert(curr_move.amount == 30, 'Amount is wrong');

        // set winner
        actions_system.set_winner_v2(game_id, 7);

        // check total paid in this game
        let curr_game = get!(world, (game_id), Game);
        // 120
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
