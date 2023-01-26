//
//  AvailableTasks.swift
//  Simple
//
//  Created by Rastislav Smolen on 18/01/2023.
//

import Foundation
import UIKit

enum Difficulty: String {
    case easy
    case normal
    case hard
    func toString()->String{
        self.rawValue
    }
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
    
    func saveTasks(difficulty: Difficulty,amountLeft: Int) {
       userDefaults.setValue(amountLeft, forKey: difficulty.toString())
    }
    func fetchTask(difficulty: Difficulty) -> Int {
        userDefaults.integer(forKey: difficulty.toString())
    }
    func reachedMaxTask(difficulty:Difficulty)-> Bool {
        switch difficulty {
        case .easy: return fetchTask(difficulty: difficulty) == 3 ? true : false
        case .normal: return fetchTask(difficulty: difficulty) == 2 ? true : false
        case .hard: return fetchTask(difficulty: difficulty) == 1 ? true : false
        }
    }
    
    func taskWasAdded(kind: Difficulty) {
        switch kind {
        case .easy:
            easyTasks = fetchAvailableTasks(difficulty: .easy)
            easyTasks += 1
            userDefaults.setValue(easyTasks, forKey: kind.toString())
        case .normal:
            normalTasks = fetchAvailableTasks(difficulty: .normal)
            normalTasks += 1
            userDefaults.setValue(normalTasks, forKey: kind.toString())
        case .hard:
            hardTasks = fetchAvailableTasks(difficulty: .hard)
            hardTasks += 1
            userDefaults.setValue(hardTasks, forKey: kind.toString())
        }
    }
    func taskWasRemoved(kind: Difficulty) {
        switch kind {
        case .easy:
            easyTasks = fetchAvailableTasks(difficulty: .easy)
            easyTasks -= 1
            userDefaults.setValue(easyTasks, forKey: kind.toString())
        case .normal:
            normalTasks = fetchAvailableTasks(difficulty: .normal)
            normalTasks -= 1
            userDefaults.setValue(normalTasks, forKey: kind.toString())
        case .hard:
            hardTasks = fetchAvailableTasks(difficulty: .hard)
            hardTasks -= 1
            userDefaults.setValue(hardTasks, forKey: kind.toString())
        }
    }
    func updateLabel(kind: Difficulty,label: UILabel) {
        fetchAllAlvailableTasks()
        switch kind {
        case .easy:
            label.text = "Easy: \(easyTasks)"
        case .normal:
            label.text = "Normal: \(normalTasks)"
        case .hard:
            label.text = "Hard: \(hardTasks)"
        }
    }
    
    func fetchAvailableTasks(difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:   return userDefaults.integer(forKey: "easy")
        case.normal:  return userDefaults.integer(forKey: "normal")
        case .hard:   return userDefaults.integer(forKey: "hard")
        }
    }
}
