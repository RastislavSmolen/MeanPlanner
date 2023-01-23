//
//  LevelUpSkill.swift
//  Simple
//
//  Created by Rastislav Smolen on 23/01/2023.
//

import Foundation
//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
import AVFoundation
import CoreData
import UIKit

class LevelUpSkill {
    
    //MARK: variables
#warning("we can move all of these to user defaults for better usage")
    var level : Int?
    var experience :  Float?
    var maximumExperience : Float?
    var convertedExperience : Float?
    var player: AVAudioPlayer?
    var readyToLevelUp : Bool?
    //MARK: constants
    let userDefaults = UserDefaults.standard
    var skills: [NSManagedObject] = []
    let coins = Coins()
    let index = IndexPath()
    let coreData = CoreDataSystem()
    
    //MARK: Bussiness Logic
    func convertedXP(xp: Float,maxXP: Float)-> Float {
        return xp / maxXP
    }
    
    func processXP(skillName: String, maxXP: Float, currentXP: Float, currentLevel: Int,index: Int) {
        if isReadyToLevelUp(maxProgress: maxXP, currentProgress: currentXP) {
            maximumExperience = calculateMaxXP(maxXP: maxXP)
            level = levelUp(currentLevel: currentLevel)
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
            readyToLevelUp = true
            updateCoreData(skillName: skillName, skillLevel: level ?? 0, skillXP: experience ?? 0.0, skillMaxXP: maximumExperience ?? 0.0, index: index)
        } else {
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
            updateCoreData(skillName: skillName, skillLevel: currentLevel , skillXP: experience ?? 0.0 , skillMaxXP: maxXP , index: index)
            readyToLevelUp = false
            
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
    func isReadyForMajorLevelUp(level: Int) -> Bool {
        coins.addCoins(amount: 1000)
        return level % 5 == 0 ? true : false
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
//MARK: - CORE DATA
extension LevelUpSkill {
    func updateCoreData(skillName: String, skillLevel: Int, skillXP: Float, skillMaxXP: Float, index: Int){
        coreData.updateCoreDataOfSkill(skillName: skillName, skillLevel: skillLevel, skillXP: skillXP, skillMaxXP: skillMaxXP, index: index)
    }
}

