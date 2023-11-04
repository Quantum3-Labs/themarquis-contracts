use starknet::ContractAddress;
use l2::the_marquis::models::{Choice};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState, playerA_address: ContractAddress, playerB_address: ContractAddress) -> u32;
    fn spawn_v2(self: @TContractState) -> u32;
    fn move(self: @TContractState, game_id: u32, player_address: ContractAddress, choice1: Choice, amount1: u32, choice2: Choice, amount2: u32);
    fn move_v2(self: @TContractState, game_id: u32, player_address: ContractAddress, choice: Choice, amount: u32);
    fn set_winner(self: @TContractState, game_id: u32, winning_number: u8);
    fn set_winner_v2(self: @TContractState, game_id: u32, winning_number: u8);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, get_caller_address};
    use l2::the_marquis::models::{Game, GameTurn, Choice, Move};
    use l2::the_marquis::utils::{betting, seed, random, is_winning_move, get_multiplier};
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
        amount: u32
    }

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState, playerA_address: ContractAddress, playerB_address: ContractAddress) -> u32{
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();

            // Get the address of the current caller, possibly the player's address.
            // let player = get_caller_address();
            set!(
                world,
                (
                    Game {
                        game_id, playerA: playerA_address, playerB: playerB_address, playerA_earned_amount: 0, playerB_earned_amount: 0, move_count: 0, last_total_paid: 0
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

        fn spawn_v2(self: @ContractState) -> u32{
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();
            game_id
        }

        // Implementation of the move function for the ContractState struct.
            fn move(self: @ContractState, game_id: u32, player_address: ContractAddress, choice1: Choice, amount1: u32, choice2: Choice, amount2: u32) {
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

        // Implementation of the move function for the ContractState struct.
        fn move_v2(self: @ContractState, game_id: u32, player_address: ContractAddress, choice: Choice, amount: u32) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Retrieve current game and game_turn data from the world.
            let MAX_AMOUNT_MOVES = 100;
            let mut curr_game = get!(world, game_id, Game);
            assert(curr_game.move_count <= MAX_AMOUNT_MOVES, 'Moves limit reached');
            assert(choice.into() != 48, 'Choice cannot be empty move');
            assert(amount > 0, 'Amount cannot be zero');

            // fetch current move_model
            let mut curr_move = get!(world, (game_id, curr_game.move_count), Move);
            curr_move.player = player_address;
            curr_move.choice = choice;
            curr_move.amount = amount;

            // update move count
            curr_game.move_count = curr_game.move_count + 1;
            set!(world, (curr_game, curr_move));
        }

        fn set_winner_v2(self: @ContractState, game_id: u32, winning_number: u8) {

            let world = self.world_dispatcher.read();
            let mut curr_game = get!(world, game_id, Game);

            // get number of moves  
            let move_count = curr_game.move_count;

            let mut curr_move_counter = 0;
            let mut aggregate_amount = 0;
            // iterate over moves
            loop {
                if curr_move_counter == move_count {
                    break;
                }
                let curr_move = get!(world, (game_id, curr_move_counter), Move);
                // check if player choice is winning
                let is_choice_winning = is_winning_move(curr_move.choice, winning_number);
                if is_choice_winning {
                    let multiplier = get_multiplier(curr_move.choice);
                    aggregate_amount = aggregate_amount + curr_move.amount * multiplier;
                }
                curr_move_counter = curr_move_counter + 1;
            };

            // update game state
            curr_game.last_total_paid = aggregate_amount;
            curr_game.move_count = 0;
            set!(world, (curr_game));
        }

        fn set_winner(self: @ContractState, game_id: u32, winning_number: u8) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Retrieve current game and game_turn(from playerA and playerB) data from the world.
            let mut game = get!(world, game_id, Game);
            let game_turn_pA = get!(world, (game_id, game.playerA), GameTurn);
            let game_turn_pB = get!(world, (game_id, game.playerB), GameTurn);

            // check if playerA choices or playerB choices are winning
            let is_choice1_pA_winning = is_winning_move(game_turn_pA.choice1, winning_number);
            let is_choice2_pA_winning = is_winning_move(game_turn_pA.choice2, winning_number);
            let is_choice1_pB_winning = is_winning_move(game_turn_pB.choice1, winning_number);
            let is_choice2_pB_winning = is_winning_move(game_turn_pB.choice2, winning_number);

            if is_choice1_pA_winning {
                let multiplier = get_multiplier(game_turn_pA.choice1);
                game.playerA_earned_amount = game.playerA_earned_amount + game_turn_pA.amount1 * multiplier;
            }  
            if is_choice2_pA_winning {
                let multiplier = get_multiplier(game_turn_pA.choice2);
                game.playerA_earned_amount = game.playerA_earned_amount + game_turn_pA.amount2 * multiplier;
            }
            if is_choice1_pB_winning {
                let multiplier = get_multiplier(game_turn_pB.choice1);
                game.playerB_earned_amount = game.playerB_earned_amount + game_turn_pB.amount1 * multiplier;
            }  
            if is_choice2_pB_winning {
                let multiplier = get_multiplier(game_turn_pB.choice2);
                game.playerB_earned_amount = game.playerB_earned_amount + game_turn_pB.amount2 * multiplier;
            }
            set!(world, (game));
        }
}}
