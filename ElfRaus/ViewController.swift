//
//  ViewController.swift
//  ElferRaus
//
//  Created by F.T. Boie on 18/02/2019.
//  Copyright © 2019 F.T. Boie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = ElfRaus()
    
    //@IBOutlet var playingField: [UILabel]!
    @IBOutlet var playingField: [PlayingCardView]!{didSet{
        playingField[1].setCardViewColor(cardColor: UIColor.yellow);
        playingField[2].setCardViewColor(cardColor: UIColor.yellow);
        playingField[3].setCardViewColor(cardColor: UIColor.yellow);
        playingField[4].setCardViewColor(cardColor: UIColor.red);
        playingField[5].setCardViewColor(cardColor: UIColor.red);
        playingField[6].setCardViewColor(cardColor: UIColor.red);
        playingField[7].setCardViewColor(cardColor: UIColor.green);
        playingField[8].setCardViewColor(cardColor: UIColor.green);
        playingField[9].setCardViewColor(cardColor: UIColor.green);
        playingField[10].setCardViewColor(cardColor: UIColor.blue);
        playingField[11].setCardViewColor(cardColor: UIColor.blue);
        playingField[12].setCardViewColor(cardColor: UIColor.blue);
        }
    }
    
    
    @IBOutlet weak var playerCard1: UIButton!
    @IBOutlet weak var playerCard2: UIButton!
    @IBOutlet weak var playerCard3: UIButton!
    @IBOutlet weak var playerCard4: UIButton!
    @IBOutlet weak var playerCard5: UIButton!{didSet{showHand();updateViewFromModel()}}
    
    @IBOutlet var cardButtons: [UIButton]!
    //for testing, should be linked to hand in the game
    var hand = [Card]()
    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    

    @IBAction func drawButton(_ sender: UIButton) {
        //draw action
        //playerCard1.setTitle("test", for: .normal)
        game.drawCard("Player")
        //showHand()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            // only send information to model if card is present
            if(cardButtons[cardNumber].backgroundColor == UIColor.lightGray){
                game.chooseCard(at: hand[cardNumber].identifier, "Player")
                updateViewFromModel()
            }
        } else {
            print("choosen card was not in cardButtons")
        }
        showHand()
    }
    
    @IBAction func PlayerHandGoLeft(_ sender: UIButton) {
        //show more cards to the left in the player hand
    }
    @IBAction func PlayerHandGoRight(_ sender: UIButton) {
        //show more cards to the right in the player hand
    }
    
    @IBAction func YellowButton(_ sender: UIButton) {
        //only show yellow cards
    }
    @IBAction func RedButton(_ sender: UIButton) {
        //only show red cards
    }
    @IBAction func GreenButton(_ sender: UIButton) {
        //only show green cards
    }
    @IBAction func BlueButton(_ sender: UIButton) {
        //only show blue cards
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        //next card
        showHand()
        var played = 0
        var cardsModel = game.getCardsModel()
        cardsModel.shuffle()
        var card = 0
        while (card < 5),(card<cardsModel.endIndex){
            //if(card < cardsModel.endIndex){
                print(card, cardsModel.endIndex)
                let valid = game.chooseCard(at: cardsModel[card].identifier, "Model")
                if valid{
                    played += 1
                    card = 0
                } else{
                    card+=1
                }
            //}
        }

        game.drawCard("Model")
        updateViewFromModel()
        
    }
    
    
    func showHand(){
        hand = game.getCardsPlayer()
        hand.shuffle()
        
        for button in 0...cardButtons.endIndex-1{
            cardButtons[button].setPlayerCardView(handCards: hand, cardIndex: button)
        }
        
        //one way of handeling too few cards in the players hand... but maybe you find a better solution :)
//        playerCard1.setPlayerCardView(handCards: hand, cardIndex: 0)
//        playerCard2.setPlayerCardView(handCards: hand, cardIndex: 1)
//        playerCard3.setPlayerCardView(handCards: hand, cardIndex: 2)
//        playerCard4.setPlayerCardView(handCards: hand, cardIndex: 3)
//        playerCard5.setPlayerCardView(handCards: hand, cardIndex: 4)


        print("showHand")

    }
    
    func updateViewFromModel(){
        //update playing field view
        updatePlayingFieldView()

    }
    
    func updatePlayingFieldView(){
        playingField[1].setCardView(cardNumber: game.playedCards.yellow_low ?? 0)
        playingField[2].setCardView(cardNumber: game.playedCards.yellow_11 ? 11:-11)
        playingField[3].setCardView(cardNumber: game.playedCards.yellow_high ?? 0)
        playingField[4].setCardView(cardNumber: game.playedCards.red_low ?? 0)
        playingField[5].setCardView(cardNumber: game.playedCards.red_11 ? 11:-11)
        playingField[6].setCardView(cardNumber: game.playedCards.red_high ?? 0)
        playingField[7].setCardView(cardNumber: game.playedCards.green_low ?? 0)
        playingField[8].setCardView(cardNumber: game.playedCards.green_11 ? 11:-11)
        playingField[9].setCardView(cardNumber: game.playedCards.green_high ?? 0)
        playingField[10].setCardView(cardNumber: game.playedCards.blue_low ?? 0)
        playingField[11].setCardView(cardNumber: game.playedCards.blue_11 ? 11:-11)
        playingField[12].setCardView(cardNumber: game.playedCards.blue_high ?? 0)
        
        
        for card in playingField{
            card.setNeedsDisplay()
            card.setNeedsLayout()
            //print("update")
        }
    }
    
}

// handles setting hand with too few cards
extension UIButton {
    func setPlayerCardView(handCards: [Card], cardIndex: Int){
        //only accepts this
        if (cardIndex < handCards.count && cardIndex>=0) {
            self.setTitle(String(handCards[cardIndex].number), for: .normal)
            self.setTitleColor(handCards[cardIndex].color, for: .normal)
            self.backgroundColor = UIColor.lightGray
            
        }else {
            //print("player has one card to few")
            self.setTitle("", for: .normal)
            self.setTitleColor(UIColor.black, for: .normal)
            self.backgroundColor = UIColor.groupTableViewBackground
            
        }
    }
}


