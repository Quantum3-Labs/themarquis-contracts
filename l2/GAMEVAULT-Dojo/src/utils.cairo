use l2::models::{GameTurn, Choice};

fn betting(game_turn: GameTurn, choice: Choice, amount: u8) -> GameTurn {
    GameTurn {
        game_id: game_turn.game_id,
        player: game_turn.player,
        choice,
        amount,
    }
}

fn seed() -> felt252 {
    starknet::get_tx_info().unbox().transaction_hash
}

fn random(seed: felt252, max: u8) -> u8 {
    let seed: u256 = seed.into();
    let mod_res: u8 = (seed.low % max.into()).try_into().unwrap();
    // We make sure that the result is not 0
    mod_res + 1
}