use starknet::ContractAddress;
use l2::the_marquis::models::{Choice};
use l2::erc20_dojo::erc20::{ERC20CamelOnlyImpl};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState) -> u32;
    fn move(self: @TContractState, game_id: u32, player_address: ContractAddress, choice: Choice, amount: u32);
    fn set_winner(self: @TContractState, game_id: u32, winning_number: u8);
 }

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, get_caller_address};
    use l2::the_marquis::models::{Game, Choice, Move};
    use l2::the_marquis::utils::{seed, random, is_winning_move,get_multiplier, make_move};
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
        fn spawn(self: @ContractState) -> u32{
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();

            // Init a new game and default values
            set!(
                world,
                (
                    Game {
                        game_id, move_count:0, last_total_paid:0
                    }
            ));
            game_id
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, game_id: u32, player_address: ContractAddress, choice: Choice, amount: u32) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            let MAX_AMOUNT_MOVES = 100;
            let mut curr_game = get!(world, game_id, Game);
            assert(curr_game.move_count <= MAX_AMOUNT_MOVES, 'Moves limit reached');
            assert(choice.into() != 48, 'Choice cannot be empty move');
            assert(amount > 0, 'Amount cannot be zero');

            // create new move
            let move_id = curr_game.move_count +1;
            let new_move = make_move(game_id, move_id, player_address, choice, amount);

            // update move count
            curr_game.move_count = move_id;
            set!(world, (curr_game, new_move));
        }

        fn set_winner(self: @ContractState, game_id: u32, winning_number: u8) {

            let world = self.world_dispatcher.read();
            let mut curr_game = get!(world, game_id, Game);

            // get number of moves  
            let move_count = curr_game.move_count;

            let mut curr_move_counter = 0;
            let mut aggregate_amount = 0;
            // iterate over moves
            loop {
                if curr_move_counter > move_count {
                    break;
                }
                let curr_move = get!(world, (game_id, curr_move_counter), Move);
                // check if player choice is winning
                let is_choice_winning = is_winning_move(curr_move.choice, winning_number);
                if is_choice_winning {
                    let player_earned_amount = curr_move.amount * get_multiplier(curr_move.choice);
                    // todo: transfer earned amount to player
                    // erc20.transfer(curr_move.player, player_earned_amount);
                    aggregate_amount = aggregate_amount + player_earned_amount
                }
                curr_move_counter = curr_move_counter + 1;
            };

            // update game state
            curr_game.last_total_paid = aggregate_amount;
            curr_game.move_count = 0;
            set!(world, (curr_game));
        }
    }
}
