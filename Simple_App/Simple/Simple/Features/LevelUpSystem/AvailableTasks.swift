//
//  AvailableTasks.swift
//  Simple
//
//  Created by Rastislav Smolen on 18/01/2023.
//

import Foundation

enum Difficulty {
    case easy
    case normal
    case hard
}
class AvailableTask {
    
    let userDefaults = UserDefaults.standard
    var easyTasks = Int()
    var normalTasks = Int()
    var hardTasks = Int()
    
    func fetchAllAlvailableTasks() {
        easyTasks = fetchAvailableTasks(difficulty: .easy)
        normalTasks = fetchAvailableTasks(difficulty: .normal)
        hardTasks = fetchAvailableTasks(difficulty: .hard)
    }
    func saveTasks(difficulty: Difficulty,amountLeft: Int ) {
        switch difficulty {
        case .easy: userDefaults.setValue(amountLeft, forKey: "easy")
        case .normal: userDefaults.setValue(amountLeft, forKey: "normal")
        case .hard: userDefaults.setValue(amountLeft, forKey: "hard")
        }
       
    }
    func fetchAvailableTasks(difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:   return userDefaults.integer(forKey: "easy")
        case.normal:  return userDefaults.integer(forKey: "normal")
        case .hard:   return userDefaults.integer(forKey: "hard")
        }
    }
    
    func isAbleToAddAnotherTask(_ difficulty: Difficulty,amountLeft: Int)-> Bool {
        switch difficulty {
        case .easy: return canAddAnotherTask(difficulty: difficulty, amount: amountLeft)
        case .normal: return canAddAnotherTask(difficulty: difficulty, amount: amountLeft)
        case .hard: return canAddAnotherTask(difficulty: difficulty, amount: amountLeft)
        }
    }
    
    func canAddAnotherTask(difficulty: Difficulty,amount: Int)-> Bool {
        var count = amount
        if amount > 1 {
            count -= 1
            saveTasks(difficulty: difficulty, amountLeft: count)
            return true
        } else {
            saveTasks(difficulty: difficulty, amountLeft: 0)
            return false
        }
    }
    func checkTaskAvailability(difficulty: Difficulty)-> Bool {
        let tasks = fetchAvailableTasks(difficulty: difficulty)
        return tasks > 0 ? true : false
    }
}
