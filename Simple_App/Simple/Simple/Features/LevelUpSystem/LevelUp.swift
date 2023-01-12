//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
class LvlUp {
    
    var level : Int?
    
    var currentProgress :  Float?
    var maximumProgress : Float?

    
    func isReadyToLevelUp(maxProgress: Float, currentProgress: Float)-> Bool {
        return  currentProgress >= maxProgress ? true : false
    }
    func processProgress(maxProgress: Float, currentProgress: Float, currentLevel: Int) {
        if isReadyToLevelUp(maxProgress: maxProgress, currentProgress: currentProgress) {
            calculateMaxProgress(maxProgress: maxProgress)
            levelUp(currentLevel: currentLevel)
            processNewExperience(currentExperience: currentProgress, maxExperience: maxProgress)
        } else {
            
        }
    }
    func calculateMaxProgress(maxProgress: Float)  {
        maximumProgress = maxProgress + (maxProgress * 0.20)
    }
    
    func levelUp(currentLevel: Int){
        level = currentLevel + 1
    }
    func processNewExperience(currentExperience: Float, maxExperience: Float) {
        if isBelowZero(currentExperience: currentExperience, maxExperience: maxExperience) {
            currentProgress = (currentExperience - maxExperience)
        } else {
            currentProgress = currentExperience
        }
    }
    func isBelowZero(currentExperience: Float, maxExperience: Float)-> Bool {
        return maxExperience - currentExperience <= 0
    }
}
