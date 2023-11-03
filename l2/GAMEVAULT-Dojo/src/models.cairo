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
    One: (),
    Two: (),
    Three: (),
    Four: (),
    Five: (),
    Six: (),
    Seven: (),
    Eight: (),
    Nine: (),
    Ten: (),
    Eleven: (),
    Twelve: (),
    Thirteen: (),
    Fourteen: (),
    Fifteen: (),
    Sixteen: (),
    Seventeen: (),
    Eighteen: (),
    Nineteen: (),
    Twenty: (),
    TwentyOne: (),
    TwentyTwo: (),
    TwentyThree: (),
    TwentyFour: (),
    TwentyFive: (),
    TwentySix: (),
    TwentySeven: (),
    TwentyEight: (),
    TwentyNine: (),
    Thirty: (),
    ThirtyOne: (),
    ThirtyTwo: (),
    ThirtyThree: (),
    ThirtyFour: (),
    ThirtyFive: (),
    ThirtySix: (),
    Zero: (),
    OneToTwelve: (),
    ThirteenToTwentyFour: (),
    TwentyFiveToThirtyFive: (),
    OneToEighteen: (),
    NineteenToThirtyFive: (),
    FirstLinen: (),
    SecondLine: (),
    ThirdLine: (),
    Even: (),
    Odd: (),
}


impl ChoiceIntoFelt252 of Into<Choice, felt252> {
    fn into(self: Choice) -> felt252 {
        match self {
            Choice::None(()) => 0,
            Choice::One(()) => 1,
            Choice::Two(()) => 2,
            Choice::Three(()) => 3,
            Choice::Four(()) => 4,
            Choice::Five(()) => 5,
            Choice::Six(()) => 6,
            Choice::Seven(()) => 7,
            Choice::Eight(()) => 8,
            Choice::Nine(()) => 9,
            Choice::Ten(()) => 10,
            Choice::Eleven(()) => 11,
            Choice::Twelve(()) => 12,
            Choice::Thirteen(()) => 13,
            Choice::Fourteen(()) => 14,
            Choice::Fifteen(()) => 15,
            Choice::Sixteen(()) => 16,
            Choice::Seventeen(()) => 17,
            Choice::Eighteen(()) => 18,
            Choice::Nineteen(()) => 19,
            Choice::Twenty(()) => 20,
            Choice::TwentyOne(()) => 21,
            Choice::TwentyTwo(()) => 22,
            Choice::TwentyThree(()) => 23,
            Choice::TwentyFour(()) => 24,
            Choice::TwentyFive(()) => 25,
            Choice::TwentySix(()) => 26,
            Choice::TwentySeven(()) => 27,
            Choice::TwentyEight(()) => 28,
            Choice::TwentyNine(()) => 29,
            Choice::Thirty(()) => 30,
            Choice::ThirtyOne(()) => 31,
            Choice::ThirtyTwo(()) => 32,
            Choice::ThirtyThree(()) => 33,
            Choice::ThirtyFour(()) => 34,
            Choice::ThirtyFive(()) => 35,
            Choice::ThirtySix(()) => 36,
            Choice::Zero(()) => 37,
            Choice::OneToTwelve(()) => 38,
            Choice::ThirteenToTwentyFour(()) => 39,
            Choice::TwentyFiveToThirtyFive(()) => 40,
            Choice::OneToEighteen(()) => 41,
            Choice::NineteenToThirtyFive(()) => 42,
            Choice::FirstLinen(()) => 43,
            Choice::SecondLine(()) => 44,
            Choice::ThirdLine(()) => 45,
            Choice::Even(()) => 46,
            Choice::Odd(()) => 47,
        }
    }
}

// impl ChoiceMultiplierFelt252 of Multiplier<Choice, felt252> {
//    fn get_multiplier(Self: Choice) -> felt252 {
//        match choice {
//            Choice::None(()) => 31,
//            Choice::Zero(()) => 41, // special one biggest win
//            Choice::One(()) => 31,
//            Choice::Two(()) => 31,
//            Choice::Three(()) => 31,
//            Choice::Four(()) => 31,
//            Choice::Five(()) => 31,
//            Choice::Six(()) => 31,
//            Choice::Seven(()) => 31,
//            Choice::Eight(()) => 31,
//            Choice::Nine(()) => 31,
//            Choice::Ten(()) => 31,
//            Choice::Eleven(()) => 31,
//            Choice::Twelve(()) => 31,
//            Choice::Thirteen(()) => 31,
//            Choice::Fourteen(()) => 31,
//            Choice::Fifteen(()) => 31,
//            Choice::Sixteen(()) => 31,
//            Choice::Seventeen(()) => 31,
//            Choice::Eighteen(()) => 31,
//            Choice::Nineteen(()) => 31,
//            Choice::Twenty(()) => 31,
//            Choice::TwentyOne(()) => 31,
//            Choice::TwentyTwo(()) => 31,
//            Choice::TwentyThree(()) => 31,
//            Choice::TwentyFour(()) => 31,
//            Choice::TwentyFive(()) => 31,
//            Choice::TwentySix(()) => 31,
//            Choice::TwentySeven(()) => 31,
//            Choice::TwentyEight(()) => 31,
//            Choice::TwentyNine(()) => 31,
//            Choice::Thirty(()) => 31,
//            Choice::ThirtyOne(()) => 31,
//            Choice::ThirtyTwo(()) => 31,
//            Choice::ThirtyThree(()) => 31,
//            Choice::ThirtyFour(()) => 31,
//            Choice::ThirtyFive(()) => 31,
//            Choice::ThirtySix(()) => 31,
//            Choice::OneToTwelve(()) => 3,
//            Choice::ThirteenToTwentyFour(()) => 3,
//            Choice::TwentyFiveToThirtyFive(()) => 3,
//            Choice::OneToEighteen(()) => 3,
//            Choice::NineteenToThirtyFive(()) => 3,
//            Choice::FirstLinen(()) => 3,
//            Choice::SecondLine(()) => 3,
//            Choice::ThirdLine(()) => 3,
//            Choice::Even(()) => 3,
//            Choice::Odd(()) => 3,
//        }
//    }

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


