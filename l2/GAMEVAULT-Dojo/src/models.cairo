use starknet::ContractAddress;
// use dojo::database::schema::{SchemaIntrospection};

#[derive(Model, Drop, Serde)]
struct Game {
    #[key]
    game_id: u32,
    winner: ContractAddress,
    playerA: ContractAddress,
    playerB: ContractAddress,
}

#[derive(Model, Drop, Serde)]
struct GameTurn {
    #[key]
    game_id: u32,
    #[key]
    player: ContractAddress,
    choice1: Choice, 
    amount1: u8,
    choice2: Choice,
    amount2: u8,
}

#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Choice {
    None: (),
    OneRed: (),
    TwoBlack: (),
    ThreeRed: (),
    FourBlack: (),
    FiveRed: (),
    SixBlack: (),
    SevenRed: (),
    EightBlack: (),
    NineRed: (),
    TenBlack: (),
    ElevenRed: (),
    TwelveBlack: (),
    ThirteenRed: (),
    FourteenBlack: (),
    FifteenRed: (),
    SixteenBlack: (),
    SeventeenRed: (),
    EighteenBlack: (),
    NineteenRed: (),
    TwentyBlack: (),
    TwentyOneRed: (),
    TwentyTwoBlack: (),
    TwentyThreeRed: (),
    TwentyFourBlack: (),
    TwentyFiveRed: (),
    TwentySixBlack: (),
    TwentySevenRed: (),
    TwentyEightBlack: (),
    TwentyNineRed: (),
    ThirtyBlack: (),
    ThirtyOneRed: (),
    ThirtyTwoBlack: (),
    ThirtyThreeRed: (),
    ThirtyFourBlack: (),
    ThirtyFiveRed: (),
    ThirtySixBlack: (),
}


impl ChoiceIntoFelt252 of Into<Choice, felt252> {
    fn into(self: Choice) -> felt252 {
        match self {
            Choice::None(()) => 0,
            Choice::OneRed(()) => 1,
            Choice::TwoBlack(()) => 2,
            Choice::ThreeRed(()) => 3,
            Choice::FourBlack(()) => 4,
            Choice::FiveRed(()) => 5,
            Choice::SixBlack(()) => 6,
            Choice::SevenRed(()) => 7,
            Choice::EightBlack(()) => 8,
            Choice::NineRed(()) => 9,
            Choice::TenBlack(()) => 10,
            Choice::ElevenRed(()) => 11,
            Choice::TwelveBlack(()) => 12,
            Choice::ThirteenRed(()) => 13,
            Choice::FourteenBlack(()) => 14,
            Choice::FifteenRed(()) => 15,
            Choice::SixteenBlack(()) => 16,
            Choice::SeventeenRed(()) => 17,
            Choice::EighteenBlack(()) => 18,
            Choice::NineteenRed(()) => 19,
            Choice::TwentyBlack(()) => 20,
            Choice::TwentyOneRed(()) => 21,
            Choice::TwentyTwoBlack(()) => 22,
            Choice::TwentyThreeRed(()) => 23,
            Choice::TwentyFourBlack(()) => 24,
            Choice::TwentyFiveRed(()) => 25,
            Choice::TwentySixBlack(()) => 26,
            Choice::TwentySevenRed(()) => 27,
            Choice::TwentyEightBlack(()) => 28,
            Choice::TwentyNineRed(()) => 29,
            Choice::ThirtyBlack(()) => 30,
            Choice::ThirtyOneRed(()) => 31,
            Choice::ThirtyTwoBlack(()) => 32,
            Choice::ThirtyThreeRed(()) => 33,
            Choice::ThirtyFourBlack(()) => 34,
            Choice::ThirtyFiveRed(()) => 35,
            Choice::ThirtySixBlack(()) => 36,
        }
    }
}

// impl ChoiceSchemaIntrospectionImpl of SchemaIntrospection<Choice> {
// #[inline(always)]
// fn size() -> usize {
//    1
//}
//
// #[inline(always)]
// fn layout(ref layout: Array<u8>) {
//         layout.append(251);
// }

// #[inline(always)]
// fn ty() -> Ty {
//     Ty::Enum(
//         Enum {
//             name: 'Choice',
//             attrs: array![].span(),
//             children: array![
//               
//             ]
//                 .span()
//         }
//     )
// }
// }

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

