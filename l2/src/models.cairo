use starknet::ContractAddress;

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

impl ChoiceIntoFelt252 of Into<Choice, felt252> {
    fn into(self: Choice) -> felt252 {
        match self {
            Choice::None(()) => 0,
            Choice::OneRed(()) => 1,
            Choice::TwoBlack(()) => 2,
            Choice::ThreeRed(()) => 3,
            Choice::FourBlack(()) => 4,
            Choice::FiveBlack(()) => 5,
            Choice::SixBlack(()) => 6,
        }
    }
}

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
    player: ContractAddress,
    choice: Choice,
    amount: u8,
}

// #[derive(Serde, Copy, Drop, Introspect)]
// enum Direction {
//     None: (),
//     Left: (),
//     Right: (),
//     Up: (),
//     Down: (),
// }
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