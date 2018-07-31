//
//  ViewController.swift
//  Beggar My Neighbor
//
//  Created by Maximilian Blood on 2/16/18.
//  Copyright © 2018 Maximilian Blood. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var turn: Int = 1
    var penaltyNum: Int = 0
    var middleDeck = [Card]()
    var player2Deck = [Card]()
    var player1Deck = [Card]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Deck.init()
        player2Deck = createPlayer2Deck()
        player1Deck = createPlayer1Deck()
        lblPlayer1Score.text = String(player1Deck.count)
        lblPlayer2Score.text = String(player2Deck.count)
        
        lblMessage.text = "Click on either deck to start playing."
        self.lblPlayer1Penalty.text = ""
        self.lblPlayer2Penalty.text = ""
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var btnResetOutlet: UIButton!
    @IBAction func btnReset(_ sender: UIButton) {
        if(isGameOver()) {  //use button to restart game
            let alertController = UIAlertController(title: "Restart Game", message: "Are you sure you want to restart the game?", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "Restart", style: .default)
            { (action:UIAlertAction) in self.viewDidLoad()
                
                self.turn = 1
                self.penaltyNum = 0
                
                self.middleDeck.removeAll()
                self.lblMiddleDeck.image = UIImage(named: "empty-middle-deck")
            }
            let action2 = UIAlertAction(title: "Cancel", style: .default)
            { (action:UIAlertAction) in print ("you've pressed cancel") }
            alertController.addAction(action1)
            alertController.addAction(action2)
            present(alertController, animated: true, completion: nil)
        } else {    //use button to reset game
            let alertController = UIAlertController(title: "Reset Game", message: "Are you sure you want to reset the game?", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "Reset", style: .default)
            { (action:UIAlertAction) in self.viewDidLoad()
                
                self.turn = 1
                self.penaltyNum = 0
                
                self.middleDeck.removeAll()
                self.lblMiddleDeck.image = UIImage(named: "empty-middle-deck")
            }
            let action2 = UIAlertAction(title: "Cancel", style: .default)
            { (action:UIAlertAction) in print ("you've pressed cancel") }
            alertController.addAction(action1)
            alertController.addAction(action2)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var lblPlayer1Score: UILabel!
    @IBOutlet weak var lblPlayer2Score: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    
    
    @IBOutlet weak var btnPlayer1DeckOutlet: UIButton!
    @IBAction func btnPlayer1Deck(_ sender: UIButton) {
        disablePlayer2Button()  //used in changeDeck() (don't let player2 click button while it's player 1's turn)
        playPlayer1Card()
    }
    @IBOutlet weak var lblMiddleDeck: UIImageView!
    
    
    @IBOutlet weak var btnPlayer2DeckOutlet: UIButton!
    @IBAction func btnPlayer2Deck(_ sender: UIButton) {
        disablePlayer1Button()  //used in changeDeck() (don't let player1 click button while it's player 2's turn)
        playPlayer2Card()
    }
    @IBOutlet weak var lblPlayer2Penalty: UILabel!
    @IBOutlet weak var lblPlayer1Penalty: UILabel!
    
    
    
    enum CardValue: Int
    {
        case TWO
        case THREE
        case FOUR
        case FIVE
        case SIX
        case SEVEN
        case EIGHT
        case NINE
        case TEN
        case JACK
        case QUEEN
        case KING
        case ACE
    }
    
    enum Suit: Int
    {
        case HEARTS
        case SPADES
        case CLUBS
        case DIAMONDS
    }
    
    

    class Card
    {
        var suit: Suit
        var cardValue: CardValue
        init(cardValue: CardValue, suit: Suit) {
            self.cardValue = cardValue
            self.suit = suit
        }

        func getSuit() -> Suit
            {
            return suit;
            }
        
        func setSuit(suit: Suit)
            {
            self.suit = suit;
            }
        
        func getCardValue() -> CardValue
            {
            return cardValue;
            }
        
        func setCardValue(cardValue: CardValue)
            {
            self.cardValue = cardValue;
            }
    }
    
    class Deck
    {
        var deck = [Card]()
        var p1deck = [Card]()
        var p2deck = [Card]()
        init(){
            for i in 0...12 {
                let cardValue: CardValue = CardValue(rawValue: i)!
                for k in 0...3 {
                    let suit: Suit = Suit(rawValue: k)!
                    let card: Card = Card(cardValue: cardValue, suit: suit)
                    self.deck.append(card)
                }
            }
            
            //shuffle deck
            var shuffledDeck = [Card]();
            for _ in 0..<deck.count
            {
                let rand = Int(arc4random_uniform(UInt32(deck.count)))
                shuffledDeck.append(deck[rand])
                deck.remove(at: rand)
            }
    
            //split shuffled deck into 2 piles
            for r in stride(from: 0, through: 51, by: 2){
                let playerCard: Card = shuffledDeck[r]
                let computerCard: Card = shuffledDeck[r+1]
                p1deck.append(playerCard)   //player 1 deck
                p2deck.append(computerCard) //player 2 deck
                }
            }
        }
    
    
    
    //--------------------------------------------------------
    //                      HELPER METHODS
    //--------------------------------------------------------
    
    func disablePlayer1Button() {
        btnPlayer1DeckOutlet.isUserInteractionEnabled = false
    }
    
    func disablePlayer2Button() {
        btnPlayer2DeckOutlet.isUserInteractionEnabled = false
    }
    
    func enablePlayer1Button() {
        btnPlayer1DeckOutlet.isUserInteractionEnabled = true
    }
    
    func enablePlayer2Button() {
        btnPlayer2DeckOutlet.isUserInteractionEnabled = true
    }
    
    func isPlayer1ButtonEnabled() -> Bool {
        return btnPlayer1DeckOutlet.isUserInteractionEnabled
    }
    
    func isPlayer2ButtonEnabled() -> Bool {
        return btnPlayer2DeckOutlet.isUserInteractionEnabled
    }
    
    func showPlayer1PenaltyModePopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 1 in Penalty Mode!", message: "Place the indicated number of cards onto the middle deck.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer2PenaltyModePopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 2 in Penalty Mode!", message: "Place the indicated number of cards onto the middle deck.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer1PenaltyModeFromPlayer2Popup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 1 in Penalty Mode!", message: "Player 1, place the indicated number of cards onto the middle deck.\nPlayer 2 is no longer in Penalty Mode.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer2PenaltyModeFromPlayer1Popup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 2 in Penalty Mode!", message: "Player 2, place the indicated number of cards onto the middle deck.\nPlayer 1 is no longer in Penalty Mode.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer1OutOfPenaltyModePopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 1 out of Penalty Mode!", message: "All cards in the middle deck go to Player 2.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showPlayer2OutOfPenaltyModePopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 2 out of Penalty Mode!", message: "All cards in the middle deck go to Player 1.", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer1WinnerPopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 1 Wins!", message: "Player 2 is out of cards. \n Player 1 is the winner!", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPlayer2WinnerPopup() {
        //declare constant
        let alertController = UIAlertController(title: "Player 2 Wins!", message: "Player 1 is out of cards. \n Player 2 is the winner!", preferredStyle: UIAlertControllerStyle.alert)
        
        //add action (function inside UIAlertController)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func decrementPenaltyNum() {
        penaltyNum -= 1
    }
    
    func createPlayer2Deck()-> [Card] {
        return Deck.init().p2deck
    }
    
    func createPlayer1Deck()-> [Card] {
        return Deck.init().p1deck
    }
    
    func isPenaltyCard(card: Card) -> Bool {
        if (card.getCardValue() == CardValue.JACK ||
            card.getCardValue() == CardValue.QUEEN ||
            card.getCardValue() == CardValue.KING ||
            card.getCardValue() == CardValue.ACE ){
            return true
        }
        else {  //not penatly card
            return false
        }
    }
    
    func isPlayer1Turn() -> Bool
    {
        if (turn%2 == 0) {
            return false
        }
        else{
            return true
        }
    }
    
    func changeDeck() {
        turn+=1
        if(isPlayer1ButtonEnabled()){   //if it WAS player1's turn, make it player2's turn
            lblMessage.text = "It's Player 2's turn"
            //print("It's Player 2's turn")
            
            disablePlayer1Button()
            enablePlayer2Button()
        }
        else if(isPlayer2ButtonEnabled()) { //if it WAS player2's turn, make it player1's turn
            lblMessage.text = "It's Player 1's turn"
            //print("It's Player 1's turn")
            
            disablePlayer2Button()
            enablePlayer1Button()
        }
    }
    
    func getPenaltyNum(card: Card) -> Int{
        var penalty : Int = 0
        if(card.getCardValue() == CardValue.JACK){
            penalty = 1
            }
        else if(card.getCardValue() == CardValue.QUEEN){
            penalty = 2
            }
        else if(card.getCardValue() == CardValue.KING){
            penalty = 3
            }
        else if(card.getCardValue() == CardValue.ACE){
            penalty = 4
            }
        return penalty
    }
    
    //game is over when one of the players has no more cards in their deck
    func isGameOver() -> Bool {
        if(player1Deck.count == 0 || player2Deck.count == 0) {
            disablePlayer1Button()
            disablePlayer2Button()
            return true
        }
        else {
            return false
        }
    }
    
    func isPlayer1Winner() -> Bool {
        //if player1's deck is empty, player1 is loser
        if(player1Deck.count == 0) {
            return false
        }
        else {
            return true
        }
    }
    
    //pre: isGameOver()
    func showWinner() {
        if(!isGameOver()) {
            print("Error! Game not over!")
        }
        
        if(isPlayer1Winner()) {
            //print("Player 1 wins!")
            lblMessage.text = "Player 1 wins!"
            showPlayer1WinnerPopup()
            
        }
        else {  //player 2 is winner
            //print("Player 2 wins!")
            lblMessage.text = "Player 2 wins!"
            showPlayer2WinnerPopup()
        }
        disablePlayer1Button()
        disablePlayer2Button()
        
        //show restart game button
        btnResetOutlet.setTitle("Restart", for: .normal)
    }
    
    
    func isInPenaltyMode() -> Bool {
        //check if more than one penalty card left (doing it both ways for assurance)
        return penaltyNum > 0 && penaltyNum != 0
    }
    
    //--------------------------------------------------------
    //                    HELPER METHODS END
    //--------------------------------------------------------
    
    
    
    
    func playPlayer1Card(){
            if(isInPenaltyMode()){ //if player1 in penalty mode
                //place top card of player deck on middle deck
                let currentCard: Card = player1Deck.first!
                middleDeck.append(currentCard)
                player1Deck.removeFirst()
                lblMiddleDeck.image = getCardImage(card: currentCard)
                lblPlayer1Score.text = String(player1Deck.count)
                
                //decrement penalty num
                decrementPenaltyNum()
                lblPlayer1Penalty.text = "Penalty: \n \(String(penaltyNum))"
                
                //check if current card is a penatly card
                //if true, player2 now in penatly mode; player1 out of penalty mode
                if(isPenaltyCard(card: currentCard)){
                    showPlayer2PenaltyModeFromPlayer1Popup()
                    changeDeck()
                    lblPlayer1Penalty.text = "" //do not show lbl if player1 not in penatly mode
                    penaltyNum = getPenaltyNum(card: currentCard)   //penatlyNum for player2's penatly mode
                    lblPlayer2Penalty.text = "Penalty: \n \(String(penaltyNum))"
                }
                //if current card not a penalty card, check if player 1 out of penalty mode (current card was last penatly card in penalty mode)
                //if true, it is now player2's turn: middle deck is added to player2's deck
                else if (!isInPenaltyMode()) {  //player1 is out of penalty mode
                    showPlayer1OutOfPenaltyModePopup()
                    changeDeck()
                    
                    player2Deck.append(contentsOf: middleDeck)
                    lblPlayer2Score.text = String(player2Deck.count)
                    
                    middleDeck.removeAll()
                    lblMiddleDeck.image = UIImage(named: "empty-middle-deck")
                    
                    lblPlayer1Penalty.text = "" //do not show lbl if player1 not in penatly mode
                }
            }
            else{   //if player1 NOT in penalty mode
                //place top card on middle deck
                let currentCard: Card = player1Deck.first!
                middleDeck.append(currentCard)
                player1Deck.removeFirst()
                lblMiddleDeck.image = getCardImage(card: currentCard)
                lblPlayer1Score.text = String(player1Deck.count)
                
                //check if current card is a penatly card
                //if true, player2 now in penatly mode
                if(isPenaltyCard(card: currentCard)){
                    showPlayer2PenaltyModePopup()
                    changeDeck()
                    penaltyNum = getPenaltyNum(card: currentCard)   ////penatlyNum for player2's penatly mode
                    lblPlayer2Penalty.text = "Penalty: \n \(String(penaltyNum))"
                }
                else{   //current card is not penatly card, it is player2's turn
                    changeDeck()
                }
            }
        
            //after every card, check if player's deck is empty
            //if true, game is over; show winner of game!
            if(isGameOver()){
                showWinner()
            }
    }
    
    func playPlayer2Card() {
        if(isInPenaltyMode()){ //if player2 in penalty mode
            //place top card of player deck on middle deck
            let currentCard: Card = player2Deck.first!
            middleDeck.append(currentCard)
            player2Deck.removeFirst()
            lblMiddleDeck.image = getCardImage(card: currentCard)
            lblPlayer2Score.text = String(player2Deck.count)
            
            //decrement penalty num
            decrementPenaltyNum()
            lblPlayer2Penalty.text = "Penalty: \n \(String(penaltyNum))"
            
            //check if current card is a penatly card
            //if true, player1 now in penatly mode; player2 out of penalty mode
            if(isPenaltyCard(card: currentCard)){
                showPlayer1PenaltyModeFromPlayer2Popup()
                changeDeck()
                lblPlayer2Penalty.text = "" //do not show lbl if player2 not in penatly mode
                penaltyNum = getPenaltyNum(card: currentCard)   //penatlyNum for player1's penatly mode
                lblPlayer1Penalty.text = "Penalty: \n \(String(penaltyNum))"
            }
                //if current card not a penalty card, check if player 2 out of penatly mode (current card was last penatly card in penalty mode)
                //if true, it is now player1's turn: middle deck is added to player1's deck
            else if (!isInPenaltyMode()) {  //player2 is out of penalty mode
                showPlayer2OutOfPenaltyModePopup()
                changeDeck()
                
                player1Deck.append(contentsOf: middleDeck)
                lblPlayer1Score.text = String(player1Deck.count)
                
                middleDeck.removeAll()
                lblMiddleDeck.image = UIImage(named: "empty-middle-deck")
                
                lblPlayer2Penalty.text = "" //do not show lbl if player2 not in penatly mode
            }
        }
        else{   //if player2 NOT in penalty mode
            //place top card on middle deck
            let currentCard: Card = player2Deck.first!
            middleDeck.append(currentCard)
            player2Deck.removeFirst()
            lblMiddleDeck.image = getCardImage(card: currentCard)
            lblPlayer2Score.text = String(player2Deck.count)
            
            //check if current card is a penatly card
            //if true, player1 now in penatly mode
            if(isPenaltyCard(card: currentCard)){
                showPlayer1PenaltyModePopup()
                changeDeck()
                penaltyNum = getPenaltyNum(card: currentCard)   ////penatlyNum for player1's penatly mode
                lblPlayer1Penalty.text = "Penalty: \n \(String(penaltyNum))"
            }
            else{   //current card is not penatly card, it is player1's turn
                changeDeck()
            }
        }
        
        //after every card, check if player's deck is empty
        //if true, game is over; show winner of game!
        if(isGameOver()){
            showWinner()
        }
    }
    
    
    
    func getCardImage(card: Card)->UIImage {
        var image: UIImage = #imageLiteral(resourceName: "back_blue")
        if(card.getCardValue() ==  CardValue.TWO && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "2_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.TWO && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "2_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.TWO && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "2_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.TWO && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "2_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.THREE && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "3_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.THREE && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "3_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.THREE && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "3_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.THREE && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "3_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.FOUR && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "4_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.FOUR && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "4_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.FOUR && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "4_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.FOUR && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "4_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.FIVE && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "5_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.FIVE && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "5_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.FIVE && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "5_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.FIVE && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "5_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.SIX && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "6_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.SIX && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "6_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.SIX && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "6_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.SIX && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "6_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.SEVEN && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "7_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.SEVEN && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "7_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.SEVEN && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "7_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.SEVEN && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "7_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.EIGHT && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "8_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.EIGHT && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "8_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.EIGHT && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "8_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.EIGHT && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "8_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.NINE && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "9_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.NINE && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "9_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.NINE && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "9_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.NINE && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "9_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.TEN && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "10_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.TEN && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "10_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.TEN && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "10_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.TEN && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "10_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.JACK && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "jack_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.JACK && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "jack_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.JACK && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "jack_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.JACK && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "jack_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.QUEEN && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "queen_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.QUEEN && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "queen_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.QUEEN && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "queen_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.QUEEN && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "queen_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.KING && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "king_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.KING && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "king_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.KING && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "king_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.KING && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "king_of_diamonds")
        }
        else if(card.getCardValue() ==  CardValue.ACE && card.getSuit() == Suit.HEARTS)
        {
            image = #imageLiteral(resourceName: "ace_of_hearts")
        }
        else if(card.getCardValue() ==  CardValue.ACE && card.getSuit() == Suit.CLUBS)
        {
            image = #imageLiteral(resourceName: "ace_of_clubs")
        }
        else if(card.getCardValue() ==  CardValue.ACE && card.getSuit() == Suit.SPADES)
        {
            image = #imageLiteral(resourceName: "ace_of_spades")
        }
        else if(card.getCardValue() ==  CardValue.ACE && card.getSuit() == Suit.DIAMONDS)
        {
            image = #imageLiteral(resourceName: "ace_of_diamonds")
        }
        return image
        
        
    }
    
    
    
    
    

}

