//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
class LevelUp {
    
    //MARK: variables
#warning("we can move all of these to user defaults for better usage")
    var level : Int?
    var experience :  Float?
    var maximumExperience : Float?
    var convertedExperience : Float?
    
    //MARK: constants
    let userDefaults = UserDefaults.standard
    
    //MARK: Bussiness Logic
    func convertedXP(xp: Float,maxXP: Float)-> Float {
        return xp / maxXP
    }
    func saveExperience(experienceToSave: Float,currentLevel: Int, maxXp: Float) {
        userDefaults.setValue(experienceToSave, forKey: "experience")
        userDefaults.setValue(currentLevel, forKey: "currentLevel")
        userDefaults.setValue(maxXp, forKey: "maxXp")
    }
    func loadXp() {
        level = fetchLevel()
        experience = fetchXP()
        maximumExperience = fetchMaxXp()
    }
    func fetchXP() ->Float {
        return userDefaults.float(forKey: "experience")
    }
    func fetchLevel() ->Int {
        return userDefaults.integer(forKey: "currentLevel")
    }
    func fetchMaxXp() ->Float {
        return userDefaults.float(forKey: "maxXp")
    }
    
    func processXP(maxXP: Float, currentXP: Float, currentLevel: Int) {
        if isReadyToLevelUp(maxProgress: maxXP, currentProgress: currentXP) {
            maximumExperience = calculateMaxXP(maxXP: maxXP)
            level = levelUp(currentLevel: currentLevel)
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
        }
    }
    func isReadyToLevelUp(maxProgress: Float, currentProgress: Float) -> Bool {
        return  currentProgress >= maxProgress ? true : false
    }
    func calculateMaxXP(maxXP: Float)-> Float {
        return maxXP + (maxXP * 0.20)
    }
    
    func levelUp(currentLevel: Int)-> Int {
        return currentLevel + 1
    }
    func calculateNewXP(currentXP: Float, maxXP: Float) -> Float {
        if isBelowZero(currentXP: currentXP, maxXP: maxXP) {
            return (currentXP - maxXP)
        } else {
            return currentXP
        }
    }
    func isBelowZero(currentXP: Float, maxXP: Float) -> Bool {
        return currentXP - maxXP > 0
    }
}
