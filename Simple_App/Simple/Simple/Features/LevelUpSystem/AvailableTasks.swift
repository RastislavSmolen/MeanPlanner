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
    var maxEasyTasks = Int()
    var maxNormalTasks = Int()
    var maxHardTasks = Int()

    
    func fetchAllAlvailableTasks() {
        easyTasks = fetchAvailableTasks(difficulty: .easy)
        normalTasks = fetchAvailableTasks(difficulty: .normal)
        hardTasks = fetchAvailableTasks(difficulty: .hard)
    }
    func fetchAllMaxTasks() {
        maxEasyTasks = fetchAvailableTasks(difficulty: .easy)
        maxNormalTasks = fetchAvailableTasks(difficulty: .normal)
        maxHardTasks = fetchAvailableTasks(difficulty: .hard)
    }
    func saveTasks(difficulty: Difficulty,amountLeft: Int ) {
        switch difficulty {
        case .easy: userDefaults.setValue(amountLeft, forKey: "easy")
        case .normal: userDefaults.setValue(amountLeft, forKey: "normal")
        case .hard: userDefaults.setValue(amountLeft, forKey: "hard")
        }
       
    }
    func setMaxAmountForTasks(difficulty: Difficulty,maxAmount: Int ) {
        switch difficulty {
        case .easy: userDefaults.setValue(maxAmount, forKey: "easyMax")
        case .normal: userDefaults.setValue(maxAmount, forKey: "normalMax")
        case .hard: userDefaults.setValue(maxAmount, forKey: "hardMax")
        }
    }
    func fetchMaxAmoutForTasks(difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:   return userDefaults.integer(forKey: "easyMax")
        case.normal:  return userDefaults.integer(forKey: "normalMax")
        case .hard:   return userDefaults.integer(forKey: "hardMax")
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
    func areTasksEmpty() -> Bool {
        return fetchAvailableTasks(difficulty: .easy) == 0 && fetchAvailableTasks(difficulty: .normal) == 0 && fetchAvailableTasks(difficulty: .hard) == 0 ? true : false
    }
//    func canAddTasks() -> Bool {
//        return fetchAvailableTasks(difficulty: .easy) <= fetchMaxAmoutForTasks(difficulty: .easy) && fetchAvailableTasks(difficulty: .normal) == 0 && fetchAvailableTasks(difficulty: .hard) == 0 ? true : false
//    }
    func canAddTasks(difficulty: Difficulty) -> Bool {
        switch difficulty {
        case .easy: return fetchAvailableTasks(difficulty: .easy) <= fetchMaxAmoutForTasks(difficulty: .easy)
        case .normal: return fetchAvailableTasks(difficulty: .normal) <= fetchMaxAmoutForTasks(difficulty: .normal)
        case .hard: return fetchAvailableTasks(difficulty: .hard) <= fetchMaxAmoutForTasks(difficulty: .hard)
        }
    }
    
    func taskWasFinnished(difficulty: Difficulty){
        switch difficulty {
        case .easy: addTask(difficulty: .easy, amount: fetchAvailableTasks(difficulty: .easy), maxAmount: fetchMaxAmoutForTasks(difficulty: .easy))
        case .normal: addTask(difficulty: .normal, amount: fetchAvailableTasks(difficulty: .normal), maxAmount: fetchMaxAmoutForTasks(difficulty: .normal))
        case .hard:addTask(difficulty: .hard, amount: fetchAvailableTasks(difficulty: .hard), maxAmount: fetchMaxAmoutForTasks(difficulty: .hard))
        }
    }
    func addTask(difficulty: Difficulty,amount: Int,maxAmount: Int){
        var count = amount
        if canAddTasks(difficulty: difficulty) && count != maxAmount {
            count += 1
            saveTasks(difficulty: difficulty, amountLeft: count)
        } else {
            print("cant add another task")
        }
    }
}
