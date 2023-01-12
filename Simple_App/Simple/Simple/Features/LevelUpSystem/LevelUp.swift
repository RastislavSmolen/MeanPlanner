//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
class LevelUp {
    
    var level : Int?
    
    var setProggress :  Float?
    var maximumProgress : Float?
    
    
    func isReadyToLevelUp(maxProgress: Float, currentProgress: Float)-> Bool {
        return  currentProgress >= maxProgress ? true : false
    }
    func processProgress(maxProgress: Float, currentProgress: Float, currentLevel: Int) {
        if isReadyToLevelUp(maxProgress: maxProgress, currentProgress: currentProgress) {
            calculateMaxProgress(maxProgress: maxProgress)
            levelUp(currentLevel: currentLevel)
            setProggress = calculateNewExperience(currentExperience: currentProgress, maxExperience: maxProgress)
        } else {
            
        }
    }
    func calculateMaxProgress(maxProgress: Float)  {
        maximumProgress = maxProgress + (maxProgress * 0.20)
    }
    
    func levelUp(currentLevel: Int){
        level = currentLevel + 1
    }
    
    func calculateNewExperience(currentExperience: Float, maxExperience: Float) -> Float {
        if isBelowZero(currentExperience: currentExperience, maxExperience: maxExperience) {
            return (currentExperience - maxExperience)
        } else {
            return currentExperience
        }
    }
    
    func isBelowZero(currentExperience: Float, maxExperience: Float)-> Bool {
        // 90 - 100 is more than 0
        return currentExperience - maxExperience > 0
    }
}
