module move_to_guandan::message {
    use std::error;
    use std::signer;
    use std::string;
    use std::vector;
    use aptos_std::simple_map::{SimpleMap,Self};
    use aptos_framework::event;
    use aptos_framework::randomness;

    struct Card has store,drop,copy {
        id: u64,
        value: u64,
        owner: address,
        is_used: bool
    }

    struct CardArray has store,drop {
        sender: address,
        cards: vector<Card>
    }

    struct Player has store,drop {
        addr: address,
        level: u64,
        teammate: address,
        max_card: u64,
        used_card: u64
    }

    struct Round has store,drop {
        rid: u64,
        rlevel: u64,
        last_num: u64,
        last_type: u64,
        last_sender: address,
        is_swap: bool,
        is_over: bool
    }

    struct Game has store,drop {
        gid: u64,
        rid: u64,
        player_addrs: vector<address>,
        last_order: vector<address>,
        winer: address,
        status: u64
    }

    const GLOBAL_SALT: u64 = 0;

    public entry fun init() {
        let player_map:SimpleMap<address,Player> = simple_map::create();
        let game_map:SimpleMap<u64,Game> = simple_map::create();
        let card_map:SimpleMap<address,vector<Card>> = simple_map::create();
        let game_round:SimpleMap<u64,vector<Round>> = simple_map::create();

        let deck: vector<Card> = vector::empty();

        for(i in 0..108){
            let card = Card {
                id: i,
                value: i % 54,
                owner: @0x0,
                is_used: false
            };
            vector::push_back(&mut deck,card);
        }
    }

    #[view]
    public fun judgeBoom(colors: vector<u64>,nums: vector<u64>): bool {
        let len = vector::length<u64>(&nums);
        for(i in 0..(len- 2)){
            let n1 = vector::borrow<u64>(&nums,i);
            let n2 = vector::borrow<u64>(&nums,i+1);
            if(n1 != n2) return false;
        };
        return true
    }


    // #[view]
    // public fun judgeStraight(cards: vector<Card>): (bool,bool) {
    //     let len = vector::length<Card>(&cards);
    //     if(len < 5) return (false,false);
    //     let is_straight: bool = true;
    //     let is_same_color: bool = true;
    //     for(i in 0..(len-1)){ 
    //         let c1 = vector::borrow<Card>(&cards,i);
    //         let c2 = vector::borrow<Card>(&cards,i+1);
    //         if(c1.value > 51 || c2.value > 51 || (c2.value - c1.value - 1) % 13 != 0){
    //             is_straight = false;
    //             break
    //         };
    //         if(c1.value + 1 != c2.value) is_same_color = false;
    //     };
    //     return (is_straight,is_same_color)
    // }

    // #[view]
    // public fun judgeTriplePair(cards: vector<Card>): bool {
    //     let res: bool = true;
    //     let i: u64 = 0;
    //     while(i < 5){
    //         let c1 = vector::borrow<Card>(&cards,i);
    //         let c2 = vector::borrow<Card>(&cards,i+1);
    //         if(c1.value != c2.value){
    //             res = false;
    //             break
    //         };
    //         i = i + 2;
    //     };

    //     let card0 = vector::borrow<Card>(&cards,0);
    //     let card2 = vector::borrow<Card>(&cards,2);
    //     let card4 = vector::borrow<Card>(&cards,4);
    //     if(card0.value == card2.value || card0.value == card4.value || card2.value == card4.value) res = false;
    //     return res
    // }

    // #[view]
    // public fun judgeTwoTripleSingle(cards: vector<Card>): bool {
    //     let res: bool = true;
    //     let i: u64 = 0;
    //     while(i < 5){
    //         let c1 = vector::borrow<Card>(&cards,i);
    //         let c2 = vector::borrow<Card>(&cards,i+1);
    //         let c3 = vector::borrow<Card>(&cards,i+2);
    //         if(c1.value != c2.value || c1.value != c3.value || c2.value != c3.value){
    //             res = false;
    //             break
    //         };
    //         i = i + 3;
    //     };

    //     let card0 = vector::borrow<Card>(&cards,0);
    //     let card3 = vector::borrow<Card>(&cards,3);
    //     if(card0.value == card3.value) res = false;
    //     return res
    // }

    // public fun judgeCardType(cards: &vector<Card>): (u64, u64) {

    //     let len = vector::length<Card>(cards);
    //     let card0 = vector::borrow<Card>(cards, 0);
    //     let cards_copy = copy cards;
    //     let card0_value = card0.value;
    //     if (judgeBoom(cards_copy)) {
    //             return (5, card0_value)
    //     };
    //     return (0,0)

    //     // if (len == 0) {
    //     //     return (0, 0)
    //     // } else if (len == 1) {
    //     //     return (1, card0.value)
    //     // } else if (len == 2) {
    //     //     let card1 = vector::borrow<Card>(&cards, 1);
    //     //     if (card0.value == card1.value) {
    //     //         return (2, card0.value)
    //     //     }
    //     // } else if (len == 3) {
    //     //     let card1 = vector::borrow<Card>(&cards, 1);
    //     //     let card2 = vector::borrow<Card>(&cards, 2);
    //     //     if (card0.value == card1.value && card0.value == card2.value) {
    //     //         return (3, card0.value)
    //     //     }
    //     // } else if (len == 4) {
    //     //     let card1 = vector::borrow<Card>(&cards, 1);
    //     //     let card2 = vector::borrow<Card>(&cards, 2);
    //     //     let card3 = vector::borrow<Card>(&cards, 3);
    //     //     let card0_value = card0.value;
    //     //     if (card0.value + card1.value + card2.value + card3.value == 210) {
    //     //         return (4, 53) // 2*(52+53)
    //     //     };
    //     //     if (judgeBoom(cards_copy)) {
    //     //         return (5, card0_value)
    //     //     }
    //     // } else if (len == 5) {
    //     //     let card1 = vector::borrow<Card>(&cards, 1);
    //     //     let card2 = vector::borrow<Card>(&cards, 2);
    //     //     let card3 = vector::borrow<Card>(&cards, 3);
    //     //     let card4 = vector::borrow<Card>(&cards, 4);
    //     //     if (judgeBoom(cards_copy)) {
    //     //         return (6, card0.value)
    //     //     };
    //     //     if (card0.value == card1.value && card0.value == card2.value && card3.value == card4.value) {
    //     //         return (7, card0.value)
    //     //     };
    //     //     let (is_straight, is_same_color) = judgeStraight(cards_copy);
    //     //     if (is_straight) {
    //     //         if (is_same_color) {
    //     //             return (8, card0.value)
    //     //         } else {
    //     //             return (9, card0.value)
    //     //         }
    //     //     }
    //     // } else if (len == 6) {
    //     //     if (judgeBoom(cards_copy)) {
    //     //         return (10, card0.value)
    //     //     };
    //     //     if (judgeTriplePair(cards_copy)) {
    //     //         return (11, card0.value)
    //     //     };
    //     //     if (judgeTwoTripleSingle(cards_copy)) {
    //     //         return (12, card0.value)
    //     //     }
    //     // };
    //     // return (0, 0)
    // }



    // public fun registerPlayer(playerAddr: address) {
    //     assert!(simple_map::contains_key(&mut player_map,&playerAddr) == false);
    //     let player = Player {
    //         addr: playerAddr,
    //         level: 0,
    //         teammate: playerAddr,
    //         maxcard: 0,
    //         usedcard: 0
    //     };
    //     simple_map::add(&mut player_map,playerAddr,player);
    // }

    // public fun randomTeammate(salt: u64): u64 {
    //     let randomNum = randomness::u64_integer() % 3;
    //     return randomNum;
    // }

    // #[view]
    // public fun checkGameId(gid: u64): bool {
    //     if(simple_map::contains_key(&game_map,&gid) == false) return false;
    //     let g = simple_map::borrow(&game_map,&gid);
    //     if(g.status == 0 || g.status == 3) { return false; }
    //     else { return true; }
    // }

    // public fun initGame(id: u64,playerAddrs: vector<address>,salt :u64) {
    //     assert!(simple_map::contains_key(&game_map,&id) == false);
    //     let g = Game {
    //         gid: id,
    //         rid: 0,
    //         playeraddrs: playerAddrs,
    //         lastorder: playerAddrs,
    //         winer: address(0),
    //         status: 1
    //     };
    //     let teamMate = randomTeammate(salt);
    //     let  player0Addr = vector::borrow(&playerAddrs,0);
    //     let  player1Addr = vector::borrow(&playerAddrs,1);
    //     let  player2Addr = vector::borrow(&playerAddrs,2);
    //     let  player3Addr = vector::borrow(&playerAddrs,3);
    //     let player0 = simple_map::borrow_mut(&player_map,&player0Addr);
    //     let player1 = simple_map::borrow_mut(&player_map,&player1Addr);
    //     let player2 = simple_map::borrow_mut(&player_map,&player2Addr);
    //     let player3 = simple_map::borrow_mut(&player_map,&player3Addr);
    //     if(teamMate == 0){
    //         player0.teammate = player1.addr;
    //         player1.teammate = player0.addr;
    //         player2.teammate = player3.addr;
    //         player3.teammate = player2.addr;
    //     }else if(teamMate == 1){
    //         player0.teammate = player2.addr;
    //         player2.teammate = player0.addr;
    //         player1.teammate = player3.addr;
    //         player3.teammate = player1.addr;
    //     }else{
    //         player0.teammate = player3.addr;
    //         player3.teammate = player0.addr;
    //         player1.teammate = player2.addr;
    //         player2.teammate = player1.addr;
    //     }
    // }

    // public fun getCard(cardnum: u64): (u64,u64) {
    //     let color:u64 = cardnum % 54 / 13;
    //     let num:u64 = (cardnum % 54) % 13 + 2;
    //     if(color == 4) num = num + 13;
    //     return (color,num);
    // }

    // public fun checkCardArray(sender: address,cardArr: CardArray): bool {
    //     let arraySize = vector::length(&cardArr.cards);
    //     let vec = simple_map::borrow(&card_map,&sender);
    //     for(i in 0..arraySize){
    //         let c = vector::borrow(&vec,i);
    //         if(c.owner != sender) return false;
    //     };
    //     return true;
    // }

    // public fun randomHandCard(playerAddrs: vector<address>) {
    //     let len = vector::length(&deck);
    //     assert!(len == 128);
    //     let remaining:u64 = 128;
    //     for(i in 0..27){
    //         for(j in 0..4){
    //             let randomIndex = randomness::u64_integer() % remaining;
    //             let cardNum:u64 = vector::borrow_mut(&deck,randomIndex);
    //             let temp = &cardNum;
    //             let lastNum:u64 = vector::borrow(&deck,remaining-1);
    //             cardNum = lastNum;
    //             remaining = remaining - 1;
    //             let c:u64;
    //             let n:u64;
    //             (c,n) = getCard(temp);
    //             let ownerAddr = vector::borrow(&playerAddrs,j);
    //             let cardOwner = simple_map::borrow(&player_map,&ownerAddr);
    //             let tempCard = Card {
    //                 id: i,
    //                 color: c,
    //                 num: n,
    //                 owner: cardOwner.addr,
    //                 status: true
    //             };
    //             if(n > cardOwner.maxcard) cardOwner.maxcard = n;
    //             if(i == 0) cardOwner.usedcard = 0;
    //         };
    //     };
    // }

    // public fun initRound(gameid: u64,playerAddrs: vector<address>) {
    //     let g = simple_map::borrow_mut(&game_map,gameid);
    //     assert!(g.status == 1 || g.status == 2);
    //     let r = Round {
    //         rid: g.roundid,
    //         rlevel: 0,
    //         lastnum: 0,
    //         lasttype: 0,
    //         lastsender: address(0),
    //         isswap: false,
    //         isover: false
    //     };
    //     let gr = simple_map::borrow_mut(&game_round,gameid);
    //     simple_map::add(&gr,&gameid,&r);
    //     g.roundid = g.roundid + 1;
    //     randomHandCard(playerAddrs);
    // }

    // public fun checkRoundId(gameid: u64,roundid: u64): bool {
    //     if(checkGameId(gameid) == false) return false;
    //     let roundvec = simple_map::borrow(&game_round,gameid);
    //     let r = vector::borrow(&roundvec,roundid);
    //     if(r.isover == false) { return true; }
    //     else { return false; }
    // }

    // public fun sendCardArray(gameid: u64,roundid: u64,sender: address,cardArrs: CardArray): bool {
    //     let len = vector::length(&cardArrs.cards);
    //     if(len == 0) return true;
    //     assert!(checkRoundId(gameid,roundid) == true);
    //     assert!(checkCardArray(sender,cardArrs) == true);
    //     let ctype: u64;
    //     let cnum: u64;
    //     (ctype,cnum) = judgeCardType(cardArrs.cards);
    //     if(ctype == 0) return false;
    //     let r = simple_map::borrow_mut(&game_round,&gameid,&roundid);
    //     if(r.lastSender == sender){
    //         r.lastType = cType;
    //         r.lastNum = cNum;
    //     }else {
    //         if(cType != r.lastType) { return false; }
    //         else {
    //             if(cType == 1){
    //                 if(cNum == r.level) return (r.lastNum < 15);
    //             }else return (cNum > r.lastNum); 
    //         }
    //     };
    //     return true;
    // }

    // public fun swapCard(gameid: u64,roundid: u64,fromAddr: vector<address>,toAddr: vector<address>,cards: vector<Card>,flag: bool): bool {
    //     assert!(checkRoundId(gameid,roundid) == true);
    //     let fromlen = vector::length(&fromAddr);
    //     let tolen = vector::length(&toAddr);
    //     let cardslen = vector::length(&cards);
    //     assert!(fromlen == tolen && fromlen == cardslen);
    //     let res:bool = true;
    //     let g = simple_map::borrow_mut(&game_round,&gameid,&roundid);
    //     let order = g.lastorder;
    //     let order0 = vector::borrow(&order,0);
    //     let order1 = vector::borrow(&order,1);
    //     let order2 = vector::borrow(&order,2);
    //     let order3 = vector::borrow(&order,3);
    //     let order0Player = simple_map::borrow_mut(&player_map,&order0);
    //     let order1Player = simple_map::borrow_mut(&player_map,&order1);
    //     let order2Player = simple_map::borrow_mut(&player_map,&order2);
    //     let order3Player = simple_map::borrow_mut(&player_map,&order3);
    //     if(g.status == 2){
    //         if(order0Player.teammate == order1){
    //             if(flag){
    //                 if(order2Player.maxcard != 16 || order3Player.maxcard != 16) return false;
    //             };
    //             if(fromlen != 4) return false;
    //             let from0 = vector::borrow(&fromAddr,0);
    //             let from1 = vector::borrow(&fromAddr,1);
    //             let from2 = vector::borrow(&fromAddr,2);
    //             let from3 = vector::borrow(&fromAddr,3);
    //             let to0 = vector::borrow(&toAddr,0);
    //             let to1 = vector::borrow(&toAddr,1);
    //             let to2 = vector::borrow(&toAddr,2);
    //             let to3 = vector::borrow(&toAddr,3);
    //             let card0 = vector::borrow(&cards,0);
    //             let card1 = vector::borrow(&cards,1);
    //             let card2 = vector::borrow(&cards,2);
    //             let card3 = vector::borrow(&cards,3);
    //             for(i in 0..4){
    //                 if(i == 0){
    //                     if(from0 != order0 || to0 != order3 || card0.value > 10) return false;
    //                 }else if(i == 1){
    //                     if(from1 != order1 || to1 != order2 || card1.value > 10) return false;
    //                 }else if(i == 2){
    //                     if(from2 != order2 || to2 != order1 || card2.value != order2Player.maxcard) return false;
    //                 }else {
    //                     if(from3 != order3 || to3 != order0 || card3.value != order3Player.maxcard) return false;
    //                 }
    //             };
    //         }else {
    //             if(fromlen != 2) return false;
    //             let from0 = vector::borrow(&fromAddr,0);
    //             let from1 = vector::borrow(&fromAddr,1);
    //             let to0 = vector::borrow(&toAddr,0);
    //             let to1 = vector::borrow(&toAddr,1);
    //             let card0 = vector::borrow(&cards,0);
    //             let card1 = vector::borrow(&cards,1);
    //             if(from0 != order0 || to0 != order3 || card0.value > 10) return false;
    //             if(from1 != order3 || to1 != order0 || card1.value != order3Player.maxcard) return false;
    //         }
    //     };
    //     g.isswap = res;
    //     return res;
    // }

    // public fun roundProcess(gameid: u64,roundid: u64,senderAddrs: vector<address>,arrays: vector<CardArray>): (bool,vector<address>) {
    //     assert!(checkRoundId(gameid,roundid) == true);
    //     let senderlen = vector::length(&senderAddrs);
    //     let arraylen = vector::length(&arrays);
    //     assert!(senderlen == arraylen);
    //     let g = simple_map::borrow_mut(&game_round,&gameid,&roundid);
    //     assert!(g.isswap == true);
    //     for(i in 0..senderlen){
    //         let currentSender = vector::borrow(&senderAddrs,i);
    //         let currentArray = vector::borrow(&arrays,i);
    //         if(sendCardArray(gameid,roundid,currentSender,currentArray) == false) return (false,g.lastorder);
    //         let s = simple_map::borrow(&player_map,currentSender);
    //         if(s.usedcard == 27) g.lastorder.push_back(currentSender);
    //     };
    //     let order = g.lastorder;
    //     let temporder = order;
    //     let order0 = vector::borrow(&order,0);
    //     let order1 = vector::borrow(&order,1);
    //     let order2 = vector::borrow(&order,2);
    //     let order3 = vector::borrow(&order,3);
    //     let order0Player = simple_map::borrow_mut(&player_map,&order0);
    //     let order1Player = simple_map::borrow_mut(&player_map,&order1);
    //     let order2Player = simple_map::borrow_mut(&player_map,&order2);
    //     let order3Player = simple_map::borrow_mut(&player_map,&order3);
    //     if(order0Player.teammate == order1){
    //         order0Player.level = order0Player.level + 3;
    //         order1Player.level = order1Player.level + 3;
    //     }else if(order0Player.teammate == order2){
    //         order0Player.level = order0Player.level + 2;
    //         order2Player.level = order2Player.level + 2;
    //     }else {
    //         order0Player.level = order0Player.level + 1;
    //         order3Player.level = order3Player.level + 1;
    //     };
    //     g.status = 2;
    //     if(order0Player.level >= 14){
    //         g.status = 3;
    //         g.winer = order0;
    //     };
    //     if(g.status == 2) {
    //         while(!vector::is_empty(&order)){
    //             vector::pop_back(&order);
    //         }
    //     };
    //     return (true,temporder);
    // }

    // public fun gameResultQuery(gameid: u64): (bool,address,address) {
    //     assert!(checkGameId(gameid) == true);
    //     let g = simple_map::borrow(&game_map,gameid);
    //     if(g.status != 3) { return(false,address(0),address(0)); }
    //     else {
    //         let winer = simple_map::borrow(&player_map,g.winer);
    //         let winerTeammate = winer.teammate;
    //         return (true,winer,winerTeammate);
    //     }
    // }
    
}