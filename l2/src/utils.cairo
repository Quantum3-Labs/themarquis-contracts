use l2::models::{GameTurn, Choice};

fn betting(game_turn: GameTurn, choice: Choice, amount: u8) -> GameTurn {
    GameTurn {
        game_id: game_turn.game_id,
        player: game_turn.player,
        choice,
        amount,
    }
}
