use l2::models::{GameTurn, Choice};

fn betting(game_turn: GameTurn, choice1: Choice, amount1: u32, choice2: Choice, amount2: u32) -> GameTurn {
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

        fn is_winning_move(
            choice: Choice, 
            winning_number: u8
   ) -> bool {
            let ret = match choice {
                Choice::None(()) => false,
                Choice::Zero(()) => 0 == winning_number,
                Choice::OneRed(()) => 1 == winning_number,
                Choice::TwoBlack(()) => 2 == winning_number,
                Choice::ThreeRed(()) => 3 == winning_number,
                Choice::FourBlack(()) => 4 == winning_number,
                Choice::FiveBlack(()) => 5 == winning_number,
                Choice::SixBlack(()) => 6 == winning_number,
                Choice::SevenRed(()) => 7 == winning_number,
                Choice::EightBlack(()) => 8 == winning_number,
                Choice::NineRed(()) => 9 == winning_number,
                Choice::TenBlack(()) => 10 == winning_number,
                Choice::ElevenBlack(()) => 11 == winning_number,
                Choice::TwelveRed(()) => 12 == winning_number,
                Choice::ThirteenBlack(()) => 13 == winning_number,
                Choice::FourteenBlack(()) => 14 == winning_number,
                Choice::FifteenRed(()) => 15 == winning_number,
                Choice::SixteenRed(()) => 16 == winning_number,
                Choice::SeventeenBlack(()) => 17 == winning_number,
                Choice::EighteenBlack(()) => 18 == winning_number,
                Choice::NineteenBlack(()) => 19 == winning_number,
                Choice::TwentyRed(()) => 20 == winning_number,
                Choice::TwentyOneBlack(()) => 21 == winning_number,
                Choice::TwentyTwoRed(()) => 22 == winning_number,
                Choice::TwentyThreeBlack(()) => 23 == winning_number,
                Choice::TwentyFourRed(()) => 24 == winning_number,
                Choice::TwentyFiveRed(()) => 25 == winning_number,
                Choice::TwentySixRed(()) => 26 == winning_number,
                Choice::TwentySevenRed(()) => 27 == winning_number,
                Choice::TwentyEightBlack(()) => 28 == winning_number,
                Choice::TwentyNineBlack(()) => 29 == winning_number,
                Choice::ThirtyBlack(()) => 30 == winning_number,
                Choice::ThirtyOneRed(()) => 31 == winning_number,
                Choice::ThirtyTwoBlack(()) => 32 == winning_number,
                Choice::ThirtyThreeRed(()) => 33 == winning_number,
                Choice::ThirtyFourRed(()) => 34 == winning_number,
                Choice::ThirtyFiveRed(()) => 35 == winning_number,
                Choice::OneToTwelve(()) => winning_number > 0 && winning_number < 13,
                Choice::ThirteenToTwentyFour(()) => winning_number > 12 && winning_number < 25,
                Choice::TwentyFiveToThirtyFive(()) => winning_number > 24 && winning_number < 36,
                Choice::OneToEighteen(()) => winning_number > 0 && winning_number < 19,
                Choice::NineteenToThirtyFive(()) => winning_number > 18 && winning_number < 36,
                Choice::FirstLinen(()) => winning_number % 3 == 1,
                Choice::SecondLine(()) => winning_number % 3 == 2,
                Choice::ThirdLine(()) => winning_number != 0 && winning_number % 3 == 0,
                Choice::Red(()) => winning_number == 1 || winning_number == 3 || winning_number == 7 || winning_number == 9 || winning_number == 12 || winning_number == 15 || winning_number == 16 || winning_number == 20 || winning_number == 22 || winning_number == 24 || winning_number == 25 || winning_number == 26 || winning_number == 27 || winning_number == 31 || winning_number == 33 || winning_number == 34 || winning_number == 35,
                Choice::Black(()) => winning_number == 2 || winning_number == 4 || winning_number == 5 || winning_number == 6 || winning_number == 8 || winning_number == 10 || winning_number == 11 || winning_number == 13 || winning_number == 14 || winning_number == 17 || winning_number == 18 || winning_number == 19 || winning_number == 21 || winning_number == 23 || winning_number == 28 || winning_number == 29 || winning_number == 30 || winning_number == 32,
                Choice::Even(()) => winning_number != 0 && winning_number % 2 == 0,
                Choice::Odd(()) =>  winning_number % 2 == 1,
            };
         ret
       }  

fn get_multiplier(choice: Choice) -> u32 {
    match choice {
        Choice::None(()) => 0,
        Choice::Zero(()) => 41, // special one biggest win
        Choice::OneRed(()) => 31,
        Choice::TwoBlack(()) => 31,
        Choice::ThreeRed(()) => 31,
        Choice::FourBlack(()) => 31,
        Choice::FiveBlack(()) => 31,
        Choice::SixBlack(()) => 31,
        Choice::SevenRed(()) => 31,
        Choice::EightBlack(()) => 31,
        Choice::NineRed(()) => 31,
        Choice::TenBlack(()) => 31,
        Choice::ElevenBlack(()) => 31,
        Choice::TwelveRed(()) => 31,
        Choice::ThirteenBlack(()) => 31,
        Choice::FourteenBlack(()) => 31,
        Choice::FifteenRed(()) => 31,
        Choice::SixteenRed(()) => 31,
        Choice::SeventeenBlack(()) => 31,
        Choice::EighteenBlack(()) => 31,
        Choice::NineteenBlack(()) => 31,
        Choice::TwentyRed(()) => 31,
        Choice::TwentyOneBlack(()) => 31,
        Choice::TwentyTwoRed(()) => 31,
        Choice::TwentyThreeBlack(()) => 31,
        Choice::TwentyFourRed(()) => 31,
        Choice::TwentyFiveRed(()) => 31,
        Choice::TwentySixRed(()) => 31,
        Choice::TwentySevenRed(()) => 31,
        Choice::TwentyEightBlack(()) => 31,
        Choice::TwentyNineBlack(()) => 31,
        Choice::ThirtyBlack(()) => 31,
        Choice::ThirtyOneRed(()) => 31,
        Choice::ThirtyTwoBlack(()) => 31,
        Choice::ThirtyThreeRed(()) => 31,
        Choice::ThirtyFourRed(()) => 31,
        Choice::ThirtyFiveRed(()) => 31,
        Choice::OneToTwelve(()) => 3,
        Choice::ThirteenToTwentyFour(()) => 3,
        Choice::TwentyFiveToThirtyFive(()) => 3,
        Choice::OneToEighteen(()) => 3,
        Choice::NineteenToThirtyFive(()) => 3,
        Choice::FirstLinen(()) => 3,
        Choice::SecondLine(()) => 3,
        Choice::ThirdLine(()) => 3,
        Choice::Red(()) => 2,
        Choice::Black(()) => 2,
        Choice::Even(()) => 2,
        Choice::Odd(()) => 2,
       }
    }

fn seed() -> felt252 {
    starknet::get_tx_info().unbox().transaction_hash
}

fn random(seed: felt252, max: u8) -> u8 {
    let seed: u256 = seed.into();
    let mod_res: u8 = (seed.low % max.into()).try_into().unwrap();
    mod_res
}