//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
class LevelUp {
    
    //MARK: variables
    var level : Int?
    var setProggress :  Float?
    var maximumProgress : Float?
    
    //MARK: Bussiness Logic
    func isReadyToLevelUp(maxProgress: Float, currentProgress: Float) -> Bool {
        return  currentProgress >= maxProgress ? true : false
    }
    
    func processProgress(maxProgress: Float, currentProgress: Float, currentLevel: Int) {
        if isReadyToLevelUp(maxProgress: maxProgress, currentProgress: currentProgress) {
            maximumProgress = calculateMaxProgress(maxProgress: maxProgress)
            level = levelUp(currentLevel: currentLevel)
            setProggress = calculateNewExperience(currentExperience: currentProgress, maxExperience: maxProgress)
        } else {
            
        }
    }
    
    func calculateMaxProgress(maxProgress: Float)-> Float {
        return maxProgress + (maxProgress * 0.20)
    }
    
    func levelUp(currentLevel: Int)-> Int {
       return currentLevel + 1
    }
    
    func calculateNewExperience(currentExperience: Float, maxExperience: Float) -> Float {
        if isBelowZero(currentExperience: currentExperience, maxExperience: maxExperience) {
            return (currentExperience - maxExperience)
        } else {
            return currentExperience
        }
    }
    
    func isBelowZero(currentExperience: Float, maxExperience: Float) -> Bool {
        return currentExperience - maxExperience > 0
    }
}
