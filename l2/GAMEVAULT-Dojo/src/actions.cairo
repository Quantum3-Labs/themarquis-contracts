use starknet::ContractAddress;
use l2::models::{Choice};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState, playerA_address: ContractAddress, playerB_address: ContractAddress) -> u32;
    fn move(self: @TContractState, game_id: u32, player_address: ContractAddress, choice1: Choice, amount1: u8, choice2: Choice, amount2: u8);
    fn set_winner(self: @TContractState, game_id: u32, winning_number: u8);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, get_caller_address};
    use l2::models::{Game, GameTurn,Choice};
    use l2::utils::{betting, seed, random};
    use super::IActions;

    // declaring custom event struct
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Moved: Moved,
    }

    // declaring custom event struct
    #[derive(Drop, starknet::Event)]
    struct Moved {
        game_id: u32,
        player_address: ContractAddress,
        amount: u8
    }

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState, playerA_address: ContractAddress, playerB_address: ContractAddress) -> u32{
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();
            // house address = 0x00
            let winner = starknet::contract_address_const::<0x00>();

            // Get the address of the current caller, possibly the player's address.
            // let player = get_caller_address();

            set!(
                world,
                (
                    Game {
                        game_id, winner, playerA: playerA_address, playerB: playerB_address
                    },
                    GameTurn {
                        game_id, player: playerA_address, choice1: Choice::None(()), amount1: 0, choice2: Choice::None(()), amount2: 0
                    }
                )
            );
            set!(
                world,
                (
                    GameTurn {
                        game_id, player: playerB_address, choice1: Choice::None(()), amount1: 0, choice2: Choice::None(()), amount2: 0
                    }
                )
            );
            game_id
        }

        // Implementation of the move function for the ContractState struct.
            fn move(self: @ContractState, game_id: u32, player_address: ContractAddress, choice1: Choice, amount1: u8, choice2: Choice, amount2: u8) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            //let player = get_caller_address();

            // Retrieve current game and game_turn data from the world.
            let game = get!(world, game_id, Game);
            let game_turn = get!(world, (game_id, player_address), GameTurn);

            // player's move.
            let game_turn = betting(game_turn, choice1, amount1, choice2, amount2);

            // Update the world state with the new moves data and position.
            set!(world, (game, game_turn));

            // Emit an event to the world to notify about the player's move.
            let amount = amount1 + amount2; // temp value. FIXME
            emit!(world, Moved { game_id, player_address, amount});
        }

        fn set_winner(self: @ContractState, game_id: u32, winning_number: u8) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Retrieve current game and game_turn(from playerA and playerB) data from the world.
            let mut game = get!(world, game_id, Game);
            let game_turnA = get!(world, (game_id, game.playerA), GameTurn);
            let game_turnB = get!(world, (game_id, game.playerB), GameTurn);

            let winning_number: felt252 = winning_number.into();

            if (winning_number == game_turnA.choice1.into() || winning_number == game_turnA.choice2.into()){
                game.winner = game_turnA.player;
            } else if ( winning_number == game_turnB.choice1.into() || winning_number == game_turnB.choice2.into()){
                game.winner = game_turnB.player;
            } 
            // Update the world state with the winner Todo: move set! inside nested if else
            set!(world, (game));

        }
    }
}

#[cfg(test)]
mod tests {
        use debug::PrintTrait;

    use starknet::{class_hash::Felt252TryIntoClassHash,contract_address_const};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // import models
    use l2::models::{game, game_turn};
    use l2::models::{Game, GameTurn, Choice};

    // import actions
    use super::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    use l2::utils::{seed, random};


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
        assert(game.winner == contract_address_const::<0x0>(), 'winner is wrong');
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
    #[available_gas(30000000)]
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

        // check PlayerA persist data
        let game_turn = get!(world, (game_id, playerA), GameTurn);

        // check playerA choice1
        assert(game_turn.choice1.into() == one_red_felt, 'choice is wrong');
        assert(game_turn.amount1 == pA_amount1, 'amount is wrong');

        // check playerA choice2
        assert(game_turn.choice2.into() == eight_black_felt, 'choice is wrong');
        assert(game_turn.amount2 == pA_amount2, 'amount is wrong');
     }

    #[test]
    #[available_gas(30000000)]
    fn test_fixed_winner() {
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

        // turn for playerB
        let pB_choice1 = Choice::TwoBlack(());
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
        assert(game.winner == starknet::contract_address_const::<0x1>(), 'winner is not playerA');

        
    }

    #[test]
    #[available_gas(30000000)]
    fn test_random() {
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
        let pA_amount2 = 50;

        // test playerA move
        // call move with OneRed and FourBlack choice
        actions_system.move(game_id, playerA, pA_choice1, pA_amount1, pA_choice2, pA_amount2);

        let game_turnA = get!(world, (game_id, playerA), GameTurn);

        // turn for playerB
        let pB_choice1 = Choice::TwoBlack(());
        let pB_amount1 = 20;
        let pB_choice2 = Choice::ThreeRed(());
        let pB_amount2 = 30;

        // test playerB move
        // call move with TwoBlack and ThreeRed choice
        actions_system.move(game_id, playerB, pB_choice1, pB_amount1, pB_choice2, pB_amount2);

        let game_turnB = get!(world, (game_id, playerB), GameTurn);
        
        // dummy vrf winning_number, FIXME
        let winning_number = random(pedersen::pedersen(seed(), pB_choice2.into()), 6);
        winning_number.print(); // Beacuse of seed() setup, this winning_number value is 3, then it is mapped into Choice::ThreeRed(())

        actions_system.set_winner(game_id, winning_number);

        let game = get!(world, game_id, Game);
        // dummy assert, we know pB_choice2 = Choice::ThreeRed(()), so playerB wins
        assert(game.winner == playerB, 'Wrgong winner');
        game.winner.print();  // Because of seed (), player wins
    }
}
