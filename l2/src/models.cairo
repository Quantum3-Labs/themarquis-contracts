use starknet::ContractAddress;
//use dojo::database::schema::{SchemaIntrospection};

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
    choice: Choice, //todo Array<Choice>,
    amount: u8, //todo Array<u8>
}

impl ChoiceSchemaIntrospectionImpl of SchemaIntrospection<Choice> {
    #[inline(always)]
    fn size() -> usize {
        1
    }

    #[inline(always)]
    fn layout(ref layout: Array<u8>) {
        layout.append(251);
    }

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