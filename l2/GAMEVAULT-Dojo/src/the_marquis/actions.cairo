use starknet::ContractAddress;
use l2::the_marquis::models::{Choice};
// use l2::erc20_dojo::erc20::erc_systems::ERC20Impl;
// use super::erc_systems::ERC20Impl;

#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState) -> u32;
    fn move(self: @TContractState, game_id: u32, player: ContractAddress, choice: Choice, amount: u32);
    fn choice(self: @TContractState, game_id: u32, move_id: ContractAddress, choice: Choice, amount: u32) -> u32;
    fn check_player_win(self: @TContractState, game_id: u32, player: ContractAddress, winning_number: u8) -> u32;
 }

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, contract_address_const};
    use l2::the_marquis::models::{Game,PlayerChoice, Choice, Move};
    use l2::the_marquis::utils::{seed, random, is_winning_move,get_multiplier, make_move_and_choose, make_choice};
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
            let player_address = contract_address_const::<0x0>();

            // Init a new game and default values
            set!(
                world,
                (
                    Game {
                        game_id, move_count:0
                    },
                    Move {
                        game_id, move_id:player_address, choice_count: 0
                    },
                    PlayerChoice {
                        game_id, move_id:player_address, choice_id:0, choice: Choice::None, amount: 0
                    }
            ));
            game_id
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, game_id: u32, player: ContractAddress, choice: Choice, amount: u32){
            assert(choice.into() != 48, 'Choice cannot be empty move');
            assert(amount > 0, 'Amount cannot be zero');
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            let MAX_AMOUNT_MOVES = 100;
            let mut game = get!(world, game_id, Game);
            assert(game.move_count <= MAX_AMOUNT_MOVES, 'Moves limit reached');

            // create new move
            let (new_move, new_choice) = make_move_and_choose(game_id, player, choice, amount);

            // update move count
            game.move_count = game.move_count + 1;
            set!(world, (game, new_move, new_choice));
        }

        fn choice(self: @ContractState, game_id: u32, move_id: ContractAddress, choice: Choice, amount: u32) -> u32{
            assert(choice.into() != 48, 'Choice cannot be empty move');
            assert(amount > 0, 'Amount cannot be zero');
            let world = self.world_dispatcher.read();
            let mut curr_move = get!(world, (game_id, move_id), Move);
            let new_choice_id = curr_move.choice_count + 1; // Fixme: improve here, uuid?
            let new_choice = make_choice(game_id, move_id, new_choice_id, choice, amount);
            curr_move.choice_count = new_choice_id;
            set!(world, (curr_move, new_choice));
            new_choice_id
        }

        fn check_player_win(self: @ContractState, game_id: u32, player: ContractAddress, winning_number: u8) -> u32{
            let world = self.world_dispatcher.read();
            let mut game = get!(world, game_id, Game);
            let curr_move = get!(world, (game_id, player), Move);
            // get number of choices for current move
            let choice_count = curr_move.choice_count;
            let mut curr_choice_counter = 1;
            let mut earning_amount = 0;
            // iterate over choices
            loop {
                if curr_choice_counter > choice_count {
                    break;
                }
                let curr_choice = get!(world, (game_id, player, curr_choice_counter), PlayerChoice);
                // check if player choice is winning
                let is_choice_winning = is_winning_move(curr_choice.choice, winning_number);
                if is_choice_winning {
                    let player_earned_amount = curr_choice.amount * get_multiplier(curr_choice.choice);
                    // accumulate amount per player
                    earning_amount = earning_amount + player_earned_amount
                }
                curr_choice_counter = curr_choice_counter + 1;
            };
            if earning_amount > 0 {
                // transfer total amount earned
                // erc20.transfer(player, earning_amount);
            }
            game.move_count = game.move_count - 1;
            //update game state
            set!(world, (game));
            earning_amount
        }

            //    fn interact_with_erc20(name: felt252, symbol: felt252) {
            //        self.initializer(name, symbol);
            //    }
    }
}
