//
//  ElfRaus.swift
//  ElfRaus
//
//  Created by A. Bliek on 21/02/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit


class ElfRaus {
    var cards = [Card]()
    var deck = Array(0...79)
    var cardsPlayer = [Card]()
    var cardsModel = [Card]()
    let totalCards = 80
    var cardsInDeck = 80
//    var cardsPlayedGreen = [Int]()
//    var cardsPlayedRed = [Int]()
//    var cardsPlayedBlue = [Int]()
//    var cardsPlayedYellow = [Int]()
    var playedCards = PlayedCards()
    var cardsModelClass = CardsModel()
    let actRModel = ActRModel()
    var cardsPlayerClass = CardsPlayer()
    var currentTurn = Turn(cardOptions: nil)
    
    
    var legalOptions = [Int:Card]()
    
    func getCardsPlayer() -> CardsPlayer{
        return cardsPlayerClass
    }
    
    func getCardsModel() -> [Card]{
        return cardsModel
    }
    
    func newTurn(_ player:String){
        if(player == "Player"){
            cardsModelClass.newTurn(allLegalOptions: legalOptions)
            currentTurn = Turn(cardOptions: cardsModelClass.getLegalOptions())
        }
        else{
            cardsPlayerClass.newTurn(allLegalOptions: legalOptions)
            currentTurn = Turn(cardOptions: cardsPlayerClass.getLegalOptions())
        }
    }
    
    func turnModel(){
        if(currentTurn.allowedToNextTurn()){
            return
        }else if(cardsModelClass.getLegalOptions() == nil), (currentTurn.allowedToDrawCard()){
             drawCard("model")
             turnModel()
        }else if(cardsModelClass.getLegalOptions()!.endIndex == 1){
            chooseCard(at: cardsModelClass.getLegalOptions()![0].identifier , "model")
        }else{
            let choice = actRModel.turn(cards: cardsModelClass)
            print(choice)
            for option in legalOptions{
                if(option.value.colorString == choice[0]){
                    if(option.value.direction == choice[1]){
                        chooseCard(at: option.value.identifier, "model")
                    }
                }
            }
        }
    }
    
    func drawCard(_ player: String){
        var cardIndex : Int
        print(cardsInDeck)
        if(cardsInDeck > 0),(currentTurn.allowedToDrawCard()){
            
            cardIndex = deck[0]
            deck.remove(at: 0)
            if(cardsInDeck > 0){
                if(player == "Player"){
                    cards[cardIndex].location = "Player"
                    cardsPlayer.append(cards[cardIndex])
                    cardsPlayerClass.drawCard(cards[cardIndex], allLegalOptions: legalOptions)
                    currentTurn.drawCard(cardOptions: cardsPlayerClass.getLegalOptions())
                } else{
                    cards[cardIndex].location = "Model"
                    cardsModel.append(cards[cardIndex])
                    cardsModelClass.drawCard(cards[cardIndex], allLegalOptions: legalOptions)
                    currentTurn.drawCard(cardOptions: cardsModelClass.getLegalOptions())
                }
                cardsInDeck -= 1
            }
            print(cardIndex)
        }
    }
    
    //index = indentifier = index in array cards
    func chooseCard(at index : Int, _ player : String) -> Bool{
        print("chooseCard", player)
        print(currentTurn.allowedToPlayCard())
        if(currentTurn.allowedToPlayCard()){
            if (legalOptions.index(forKey: index) != nil) {
                print("play card")
                cards[index].location = "Played"
                if(cards[index].number >= 11), (cards[index].number < 20){
                    legalOptions.updateValue(cards[index+1], forKey: index+1)
                }
                if(cards[index].number > 1), (cards[index].number <= 11){
                    legalOptions.updateValue(cards[index-1], forKey: index-1)
                }
                legalOptions.removeValue(forKey: index)
                playedCards.newPlayedCard(color: cards[index].color, number: cards[index].number)
                playedCards.printPlayedCards()
                if(player == "Player"){
                    cardsPlayerClass.playCard(cards[index], allLegalOptions: legalOptions)
                    for indexCardPlayer in 0...cardsPlayer.endIndex-1{
                        if(cardsPlayer[indexCardPlayer].identifier == index){
                            cardsPlayer.remove(at: indexCardPlayer)
                            break
                            }
                    }
                    currentTurn.playCard(cardOptions: cardsPlayerClass.getLegalOptions())
                }else{
                    
                    for indexCardModel in 0...cardsModel.endIndex-1{
                        if(cardsModel[indexCardModel].identifier == index){
                            //print("Model plays ", cardsModel[indexCardModel].number)
                            cardsModelClass.playCard(cardsModel[indexCardModel], allLegalOptions: legalOptions)
                            cardsModel.remove(at: indexCardModel)
                            
                            break
                        }
                    }
                    currentTurn.playCard(cardOptions: cardsModelClass.getLegalOptions())
                }
                
              return true
            }
            
        }
        print(index)
        return false
        
        
    }
    
    init(){
        actRModel.turn(cards: cardsModelClass)
        var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
        
        //create all cards
        for color in 0...3 {
            for number in 1...20 {
                cards.append(Card(color: colors[color],number: number,location: "Deck", identifier : color*20+number-1 ))
            }
            legalOptions.updateValue(cards[color*20+10], forKey: color*20+10)
        }
        print(cards[0])
        deck.shuffle()

        let numberOfDistributedCards = 5
        for card in 1...numberOfDistributedCards {
            let cardPlayer = deck[card]
            deck.remove(at: card)
            cards[cardPlayer].location = "Player"
            cardsPlayer.append(cards[cardPlayer])
            cardsPlayerClass.drawCard(cards[cardPlayer], allLegalOptions: legalOptions)

            let cardModel = deck[card]
            deck.remove(at: card)
            cards[cardModel].location = "Model"
            cardsModel.append(cards[cardModel])
            cardsModelClass.drawCard(cards[cardModel], allLegalOptions: legalOptions)
            cardsInDeck -= 2

        }
        newTurn("Model")
    }
    
}
