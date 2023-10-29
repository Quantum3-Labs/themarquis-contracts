use starknet::ContractAddress;
use l2::models::{Choice};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState, player_address: ContractAddress);
    fn move(self: @TContractState, choice: Choice, amount: u8);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, get_caller_address};
    use l2::models::{Game, GameTurn,Choice};
    use l2::utils::betting;
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
        player: ContractAddress,
        amount: u8
    }

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState, player_address: ContractAddress) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();
            // house address = 0x00
            let winner = starknet::contract_address_const::<0x00>();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            set!(
                world,
                (
                    Game {
                        game_id, winner, player: player_address
                    },
                    GameTurn {
                        game_id, player: player_address, choice: Choice::None(()), amount: 0
                    }
                )
            );
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, choice: Choice, amount: u8) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve current game and game_turn data from the world.
            let (mut game, game_turn) = get!(world, player, (Game, GameTurn));

            // player's move.
            let game_turn = betting(game_turn, choice, amount);

            // Update the world state with the new moves data and position.
            set!(world, (game, game_turn));

            // Emit an event to the world to notify about the player's move.
            emit!(world, Moved { player, amount });
        }
    }
}

// #[cfg(test)]
// mod tests {
//     use starknet::class_hash::Felt252TryIntoClassHash;

//     // import world dispatcher
//     use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

//     // import test utils
//     use dojo::test_utils::{spawn_test_world, deploy_contract};

//     // import models
//     use l2::models::{game, game_turn};
//     use l2::models::{Game, GameTurn, Choice};

//     // import actions
//     use super::{actions, IActionsDispatcher, IActionsDispatcherTrait};

//     #[test]
//     #[available_gas(30000000)]
//     fn test_move() {
//         // caller
//         let caller = starknet::contract_address_const::<0x1>();

//         // models
//         let mut models = array![game::TEST_CLASS_HASH, game_turn::TEST_CLASS_HASH];

//         // deploy world with models
//         let world = spawn_test_world(models);

//         // deploy systems contract
//         let contract_address = wrold
//             .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
//         let actions_system = IActionsDispatcher { contract_address };

//         // call spawn()
//         actions_system.spawn();

//         // call move with direction right
//         actions_system.move(Direction::Right(()));

//         // Check world state
//         let moves = get!(world, caller, Moves);

//         // casting right direction
//         let right_dir_felt: felt252 = Direction::Right(()).into();

//         // check moves
//         assert(moves.remaining == 9, 'moves is wrong');

//         // check last direction
//         assert(moves.last_direction.into() == right_dir_felt, 'last direction is wrong');

//         // get new_position
//         let new_position = get!(world, caller, Position);

//         // check new position x
//         assert(new_position.vec.x == 11, 'position x is wrong');

//         // check new position y
//         assert(new_position.vec.y == 10, 'position y is wrong');
//     }
// }
