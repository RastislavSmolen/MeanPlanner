//
//  Coins.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation

class Coins {
    var userDefaults = UserDefaults.standard
    let skillPoints = SkillPoints()
    var aler: Alert?
    var notEnoughtCoins: Bool?
    func saveCoins(coins: Int){
        userDefaults.setValue(coins, forKey: "coins")
    }
    func fetchCoins()-> Int {
        return userDefaults.integer(forKey: "coins")
    }
    func checkIfAbleToBuy(cost: Int) -> Bool {
        return fetchCoins() >= cost ? true : false
    }
    func buy(cost: Int, item: Item){
        
        if checkIfAbleToBuy(cost: cost) {
            saveCoins(coins: fetchCoins() - cost)
            takeTheItem(item: item)
        } else {
            print("not able to buy, not enoug coins")
        }
    }
    
    func spend(cost: Int){
        if checkIfAbleToBuy(cost: cost) {
            saveCoins(coins: fetchCoins() - cost)
            notEnoughtCoins = false
        } else {
            notEnoughtCoins = true
        }
    }
  
    func addCoins(amount: Int) {
        let coins =  fetchCoins()
        saveCoins(coins: coins + amount)
    }
    func takeTheItem(item: Item) {
        switch item {
        case .skill: skillPoints.addSkillPoint(skill: 1)
        }
    }
}
