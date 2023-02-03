//
//  GlobalLevelUpSystem.swift
//  Simple
//
//  Created by Rastislav Smolen on 23/01/2023.
//

import Foundation
enum LevelData: String {
case experience
case currentLevel
case mental
case physical
case maxXp
    func toString()-> String{
        self.rawValue
    }
}
enum ElementKind {
    case float
    case double
    case string
    case integer
}
enum Action {
    case save
    case delete
    case fetch
}

class GlobalLevelUpSystem {
    let userDefaults = UserDefaults.standard
    
    func fetchUserData(kind: ElementKind, forkey: LevelData) -> Any {
        switch kind {
        case .double: return userDefaults.double(forKey: forkey.toString()) as Double
        case .float: return userDefaults.float(forKey: forkey.toString()) as Float
        case .integer: return userDefaults.integer(forKey: forkey.toString()) as Int
        case .string:  return (userDefaults.string(forKey: forkey.toString()) ?? "") as String
        }
    }
    func saveUserData(forkey: LevelData, itemToSave: Any) {
        userDefaults.setValue(itemToSave, forKey: forkey.toString())
    }
    //func saveExperience(experienceToSave: Float,currentLevel: Int, maxXp: Float) {
    //    userDefaults.setValue(experienceToSave, forKey: "experience")
    //    userDefaults.setValue(currentLevel, forKey: "currentLevel")
    //    userDefaults.setValue(maxXp, forKey: "maxXp")
    //}
    //func loadXp() {
    //    level = fetchLevel()
    //    experience = fetchXP()
    //    maximumExperience = fetchMaxXp()
    //}
    //func fetchXP() ->Float {
    //    return userDefaults.float(forKey: "experience")
    //}
    //func fetchLevel() ->Int {
    //    return userDefaults.integer(forKey: "currentLevel")
    //}
    //func fetchMaxXp() ->Float {
    //    return userDefaults.float(forKey: "maxXp")
    //}
    //}
}
