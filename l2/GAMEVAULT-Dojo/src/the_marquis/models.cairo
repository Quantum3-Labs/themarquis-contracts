use starknet::ContractAddress;
// use dojo::database::schema::{SchemaIntrospection};

#[derive(Model, Drop, Serde)]
struct Game {
    #[key]
    game_id: u32,
    move_count: u32,
    last_total_paid: u32,
}
#[derive(Model, Drop, Serde)]
struct Move {
    #[key]
    game_id: u32,
    #[key]
    move_id: u32,
    player: ContractAddress,
    choice: Choice,
    amount: u32,
}

#[derive(Model, Drop, Serde)]
struct WorldHelperStorage {
    #[key]
    world: ContractAddress,
    owner: ContractAddress,
    usd_m_address: ContractAddress
}

#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Choice {
    None: (),
    Zero: (),
    OneRed: (),
    TwoBlack: (),
    ThreeRed: (),
    FourBlack: (),
    FiveBlack: (),
    SixBlack: (),
    SevenRed: (),
    EightBlack: (),
    NineRed: (),
    TenBlack: (),
    ElevenBlack: (),
    TwelveRed: (),
    ThirteenBlack: (),
    FourteenBlack: (),
    FifteenRed: (),
    SixteenRed: (),
    SeventeenBlack: (),
    EighteenBlack: (),
    NineteenBlack: (),
    TwentyRed: (),
    TwentyOneBlack: (),
    TwentyTwoRed: (),
    TwentyThreeBlack: (),
    TwentyFourRed: (),
    TwentyFiveRed: (),
    TwentySixRed: (),
    TwentySevenRed: (),
    TwentyEightBlack: (),
    TwentyNineBlack: (),
    ThirtyBlack: (),
    ThirtyOneRed: (),
    ThirtyTwoBlack: (),
    ThirtyThreeRed: (),
    ThirtyFourRed: (),
    ThirtyFiveRed: (),
    OneToTwelve: (),
    ThirteenToTwentyFour: (),
    TwentyFiveToThirtyFive: (),
    OneToEighteen: (),
    NineteenToThirtyFive: (),
    FirstLinen: (),
    SecondLine: (),
    ThirdLine: (),
    Red: (),
    Black: (),
    Even: (),
    Odd: (),
}


impl ChoiceIntoFelt252 of Into<Choice, felt252> {
    fn into(self: Choice) -> felt252 {
        match self {
            Choice::None(()) => 48,
            Choice::Zero(()) => 0,
            Choice::OneRed(()) => 1,
            Choice::TwoBlack(()) => 2,
            Choice::ThreeRed(()) => 3,
            Choice::FourBlack(()) => 4,
            Choice::FiveBlack(()) => 5,
            Choice::SixBlack(()) => 6,
            Choice::SevenRed(()) => 7,
            Choice::EightBlack(()) => 8,
            Choice::NineRed(()) => 9,
            Choice::TenBlack(()) => 10,
            Choice::ElevenBlack(()) => 11,
            Choice::TwelveRed(()) => 12,
            Choice::ThirteenBlack(()) => 13,
            Choice::FourteenBlack(()) => 14,
            Choice::FifteenRed(()) => 15,
            Choice::SixteenRed(()) => 16,
            Choice::SeventeenBlack(()) => 17,
            Choice::EighteenBlack(()) => 18,
            Choice::NineteenBlack(()) => 19,
            Choice::TwentyRed(()) => 20,
            Choice::TwentyOneBlack(()) => 21,
            Choice::TwentyTwoRed(()) => 22,
            Choice::TwentyThreeBlack(()) => 23,
            Choice::TwentyFourRed(()) => 24,
            Choice::TwentyFiveRed(()) => 25,
            Choice::TwentySixRed(()) => 26,
            Choice::TwentySevenRed(()) => 27,
            Choice::TwentyEightBlack(()) => 28,
            Choice::TwentyNineBlack(()) => 29,
            Choice::ThirtyBlack(()) => 30,
            Choice::ThirtyOneRed(()) => 31,
            Choice::ThirtyTwoBlack(()) => 32,
            Choice::ThirtyThreeRed(()) => 33,
            Choice::ThirtyFourRed(()) => 34,
            Choice::ThirtyFiveRed(()) => 35,
            Choice::OneToTwelve(()) => 36,
            Choice::ThirteenToTwentyFour(()) => 37,
            Choice::TwentyFiveToThirtyFive(()) => 38,
            Choice::OneToEighteen(()) => 39,
            Choice::NineteenToThirtyFive(()) => 40,
            Choice::FirstLinen(()) => 41,
            Choice::SecondLine(()) => 42,
            Choice::ThirdLine(()) => 43,
            Choice::Red(()) => 44,
            Choice::Black(()) => 45,
            Choice::Even(()) => 46,
            Choice::Odd(()) => 47,
        }
    }
}
