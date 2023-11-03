use l2::models::{GameTurn, Choice};

fn betting(game_turn: GameTurn, choice1: Choice, amount1: u8, choice2: Choice, amount2: u8) -> GameTurn {
    assert(game_turn.choice1 == Choice::None(()), 'Player has already chosen');
    assert(game_turn.amount1 == 0, 'Player has already bet amount');
    assert(game_turn.choice2 == Choice::None(()), 'Player has already chosen');
    assert(game_turn.amount2 == 0, 'Player has already bet amount');
    GameTurn {
        game_id: game_turn.game_id,
        player: game_turn.player,
        choice1,
        amount1,
        choice2,
        amount2,
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