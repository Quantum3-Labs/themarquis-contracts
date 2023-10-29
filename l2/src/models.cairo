use starknet::ContractAddress;

// #[derive(Serde, Copy, Drop, Introspect)]
// enum Direction {
//     None: (),
//     Left: (),
//     Right: (),
//     Up: (),
//     Down: (),
// }

#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Choice {
    None: (),
    OneRed: (),
    TwoBlack: (),
    ThreeRed: (),
    FourBlack: (),
    FiveBlack: (),
    SixBlack: (),
}

// impl DirectionIntoFelt252 of Into<Direction, felt252> {
//     fn into(self: Direction) -> felt252 {
//         match self {
//             Direction::None(()) => 0,
//             Direction::Left(()) => 1,
//             Direction::Right(()) => 2,
//             Direction::Up(()) => 3,
//             Direction::Down(()) => 4,
//         }
//     }
// }

#[derive(Model, Drop, Serde)]
struct Game {
     #[key]
     game_id: u32,
     winner: ContractAddress,
     player: ContractAddress,
 }

#[derive(Model, Drop, Serde)]
struct GameTurn {
    #[key]
    game_id: u32,
    #[key]
    player: ContractAddress,
    choice: Choice,
    amount: u8,
}
