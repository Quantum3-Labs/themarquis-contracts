use starknet::ContractAddress;
use l2::the_marquis::models::{Choice};
use array::{ArrayTrait, SpanTrait};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState) -> u32;
    fn move(self: @TContractState, game_id: u32, player_address: ContractAddress, choices: Array<Choice>, amounts: Array<u32>);
    fn set_winner(self: @TContractState, game_id: u32, winning_number: u8);
    fn owner(self: @TContractState) -> ContractAddress;
    fn initialize(self: @TContractState, usd_m_address: ContractAddress);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use serde::Serde;
    use starknet::SyscallResultTrait;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use l2::the_marquis::models::{Game, Choice, Move, WorldHelperStorage};
    use l2::the_marquis::utils::{seed, random, is_winning_move,get_multiplier, make_move, MAX_AMOUNT_MOVES};
    use super::IActions;

    // declaring custom event struct
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Moved: Moved,
        GameInitialized: GameInitialized
    }

    // declaring custom event struct
    #[derive(Drop, starknet::Event)]
    struct Moved {
        game_id: u32,
        player_address: ContractAddress,
        amount: u32
    }

    // declaring custom event struct
    #[derive(Drop, starknet::Event)]
    struct GameInitialized {
        #[key]
        game_id: u32
    }

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState) -> u32{

            // only owner can call this
            self._only_owner();

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
            emit!(world, GameInitialized { game_id });
            game_id
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, game_id: u32, player_address: ContractAddress, choices: Array<Choice>, amounts: Array<u32>) {

            // there are 48 choices at most
            assert(choices.len() > 0 && choices.len() <= 48 && choices.len() == amounts.len(), 'arrays length not match');
            let mut index = 0;
            let mut aggregated_amount = 0;
            loop {
                if index == choices.len() {
                    break;
                }
                let amount = (*amounts[index]).try_into().unwrap();
                self.move_internal(game_id, player_address, (*choices[index]).try_into().unwrap(), amount);
                aggregated_amount = aggregated_amount + amount;
                index = index + 1;
            };
            
            //trasnfer aggregated amount of tokens
            let result = self._transfer_from(player_address, get_contract_address(), aggregated_amount);
            assert(result, 'Transfer failed');
        }

        fn owner(self: @ContractState) -> ContractAddress {
            self._owner()
        }

        fn set_winner(self: @ContractState, game_id: u32, winning_number: u8) {

            // only owner can call this
            self._only_owner();

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
                    // transfer tokens to player
                    let result = self._transfer(curr_move.player, player_earned_amount);
                    assert(result, 'Transfer failed');
                    aggregate_amount = aggregate_amount + player_earned_amount
                }
                curr_move_counter = curr_move_counter + 1;
            };

            // update game state
            curr_game.last_total_paid = aggregate_amount;
            curr_game.move_count = 0;
            set!(world, (curr_game));
        }

        fn initialize(self: @ContractState, usd_m_address: ContractAddress) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let mut helper_storage = get!(world, (get_contract_address()), WorldHelperStorage);
            helper_storage.owner = get_caller_address();
            helper_storage.usd_m_address = usd_m_address;
            set!(world, (helper_storage));
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn move_internal(self: @ContractState, game_id: u32, player_address: ContractAddress, choice: Choice, amount: u32) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            let mut curr_game = get!(world, game_id, Game);
            assert(curr_game.move_count <= MAX_AMOUNT_MOVES, 'Moves limit reached');
            assert(choice.into() != 48, 'Choice not allowed');
            assert(amount > 0, 'Amount cannot be zero');

            // create new move
            let move_id = curr_game.move_count +1;
            let new_move = make_move(game_id, move_id, player_address, choice, amount);

            // update move count
            curr_game.move_count = move_id;
            set!(world, (curr_game, new_move));
        }

        fn _only_owner(self: @ContractState) {
            assert(self._owner() == get_caller_address(), 'Only owner');
        }

        fn _owner(self: @ContractState) -> ContractAddress {
            let world = self.world_dispatcher.read();
            let helper_storage = get!(world, (get_contract_address()), WorldHelperStorage);
            helper_storage.owner
        }

        fn _usd_m_address(self: @ContractState) -> ContractAddress {
            let world = self.world_dispatcher.read();
            let helper_storage = get!(world, (get_contract_address()), WorldHelperStorage);
            helper_storage.usd_m_address
        }
        fn _transfer_from(self: @ContractState, _from: ContractAddress, _to: ContractAddress, _amount: u32) -> bool{
            let mut call_data: Array<felt252> = ArrayTrait::new();
            Serde::serialize(@_from, ref call_data);
            Serde::serialize(@_to, ref call_data);
            Serde::serialize(@_amount, ref call_data);
            Serde::serialize(@0, ref call_data); // uint256 passed as (_amount, 0)
            let mut res = starknet::call_contract_syscall(
                self._usd_m_address(), selector!("transferFrom"), call_data.span()
            )
                .unwrap_syscall();
            Serde::<bool>::deserialize(ref res).unwrap()
        }
        fn _transfer(self: @ContractState, _to: ContractAddress, _amount: u32) -> bool{
            let mut call_data: Array<felt252> = ArrayTrait::new();
            Serde::serialize(@_to, ref call_data);
            Serde::serialize(@_amount, ref call_data);
            Serde::serialize(@0, ref call_data); // uint256 passed as (_amount, 0)
            let mut res = starknet::call_contract_syscall(
                self._usd_m_address(), selector!("transfer"), call_data.span()
            )
                .unwrap_syscall();
            Serde::<bool>::deserialize(ref res).unwrap()
        }
    }
}
