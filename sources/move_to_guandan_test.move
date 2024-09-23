#[test_only]
module move_to_guandan::tests {
    use std::signer;
    use std::unit_test;
    use std::vector;
    use std::string;
    use aptos_framework::account;
    use move_to_guandan::message;

    fun get_account(): signer {
        vector::pop_back(&mut unit_test::create_signers_for_testing(1))
    }

    #[test]
    public fun test_judge_boom() {
        let nums = vector::empty<u64>();
        vector::push_back(&mut nums, 10);
        vector::push_back(&mut nums, 10);
        vector::push_back(&mut nums, 10);
        vector::push_back(&mut nums, 10);
        assert!(message::judgeBoom(vector::empty<u64>(), nums), 1);
    }

    // #[test]
    // public fun test_judge_straight() {
    //     let cards = vector::empty<Card>();
    //     vector::push_back(&mut cards, Card { id: 1, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 2, value: 2, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 3, value: 3, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 4, value: 4, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 5, value: 5, owner: @0x1, is_used: false });
    //     let (is_straight, is_same_color) = message::judgeStraight(cards);
    //     assert!(is_straight, 0);
    //     assert!(!is_same_color, 0);
    // }

    // #[test]
    // public fun test_judge_triple_pair() {
    //     let cards = vector::empty<Card>();
    //     vector::push_back(&mut cards, Card { id: 1, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 2, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 3, value: 2, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 4, value: 2, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 5, value: 3, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 6, value: 3, owner: @0x1, is_used: false });
    //     assert!(message::judgeTriplePair(cards), 0);
    // }

    // #[test]
    // public fun test_judge_card_type() {
    //     let cards = vector::empty<Card>();
    //     vector::push_back(&mut cards, Card { id: 1, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 2, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 3, value: 1, owner: @0x1, is_used: false });
    //     vector::push_back(&mut cards, Card { id: 4, value: 1, owner: @0x1, is_used: false });
    //     let (ctype, cnum) = message::judgeCardType(cards);
    //     assert!(ctype == 4, 0);
    //     assert!(cnum == 1, 0);
    // }

    // #[test]
    // public fun test_register_player() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     message::registerPlayer(addr);
    //     assert!(simple_map::contains_key(&message::playermap, &addr), 0);
    // }

    // #[test]
    // public fun test_random_teammate() {
    //     let random_num = message::randomTeammate(12345);
    //     assert!(random_num < 3, 0);
    // }

    // #[test]
    // public fun test_check_game_id() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     assert!(message::checkGameId(1), 0);
    // }

    // #[test]
    // public fun test_init_game() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     assert!(simple_map::contains_key(&message::gamemap, &1), 0);
    // }

    // #[test]
    // public fun test_get_card() {
    //     let (color, num) = message::getCard(10);
    //     assert!(color == 0, 0);
    //     assert!(num == 12, 0);
    // }

    // #[test]
    // public fun test_check_card_array() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let card_arr = CardArray {
    //         sender: addr,
    //         cards: vector::empty<Card>()
    //     };
    //     vector::push_back(&mut card_arr.cards, Card { id: 1, value: 1, owner: addr, is_used: false });
    //     assert!(message::checkCardArray(addr, card_arr), 0);
    // }

    // #[test]
    // public fun test_random_hand_card() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::randomHandCard(player_addrs);
    //     let len = vector::length(&message::deck);
    //     assert!(len == 100, 0); // 128 - 28 (7 cards for each of 4 players)
    // }

    // #[test]
    // public fun test_init_round() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     let rounds = simple_map::borrow(&message::gameround, &1);
    //     assert!(vector::length(&rounds) == 1, 0);
    // }

    // #[test]
    // public fun test_check_round_id() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     assert!(message::checkRoundId(1, 0), 0);
    // }

    // #[test]
    // public fun test_send_card_array() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     let card_arr = CardArray {
    //         sender: addr,
    //         cards: vector::empty<Card>()
    //     };
    //     vector::push_back(&mut card_arr.cards, Card { id: 1, value: 1, owner: addr, is_used: false });
    //     assert!(message::sendCardArray(1, 0, addr, card_arr), 0);
    // }

    // #[test]
    // public fun test_swap_card() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     let from_addrs = vector::empty<address>();
    //     let to_addrs = vector::empty<address>();
    //     let cards = vector::empty<Card>();
    //     vector::push_back(&mut from_addrs, addr);
    //     vector::push_back(&mut to_addrs, addr);
    //     vector::push_back(&mut cards, Card { id: 1, value: 1, owner: addr, is_used: false });
    //     assert!(message::swapCard(1, 0, from_addrs, to_addrs, cards, true), 0);
    // }

    // #[test]
    // public fun test_round_process() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     let sender_addrs = vector::empty<address>();
    //     let card_arrs = vector::empty<CardArray>();
    //     vector::push_back(&mut sender_addrs, addr);
    //     let card_arr = CardArray {
    //         sender: addr,
    //         cards: vector::empty<Card>()
    //     };
    //     vector::push_back(&mut card_arr.cards, Card { id: 1, value: 1, owner: addr, is_used: false });
    //     vector::push_back(&mut card_arrs, card_arr);
    //     let (success, order) = message::roundProcess(1, 0, sender_addrs, card_arrs);
    //     assert!(success, 0);
    //     assert!(vector::length(&order) == 1, 0);
    // }

    // #[test]
    // public fun test_game_result_query() {
    //     let account = get_account();
    //     let addr = signer::address_of(&account);
    //     let player_addrs = vector::empty<address>();
    //     vector::push_back(&mut player_addrs, addr);
    //     message::initGame(1, player_addrs, 12345);
    //     message::initRound(1, player_addrs);
    //     let (success, winner, teammate) = message::gameResultQuery(1);
    //     assert!(!success, 0);
    //     assert!(winner == address(0), 0);
    //     assert!(teammate == address(0), 0);
    // }
}