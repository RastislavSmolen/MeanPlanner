//
//  LevelUp.swift
//  Simple
//
//  Created by Rastislav Smolen on 01/10/2022.
//

import Foundation
import AVFoundation

class LevelUp: GlobalLevelUpSystem {
    
    //MARK: variables
#warning("we can move all of these to user defaults for better usage")
    var level : Int?
    var experience :  Float?
    var maximumExperience : Float?
    var convertedExperience : Float?
    var player: AVAudioPlayer?
    var readyToLevelUp : Bool?
    let skillPoint = SkillPoints()

    let coins = Coins()
    
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
        level = fetchUserData(kind: .integer, forkey: .currentLevel) as? Int
        experience = fetchUserData(kind: .float, forkey: .experience) as? Float
        maximumExperience = fetchUserData(kind: .float, forkey: .maxXp) as? Float
    }
    
    func processXP(maxXP: Float, currentXP: Float, currentLevel: Int) {
        if isReadyToLevelUp(maxProgress: maxXP, currentProgress: currentXP) {
            maximumExperience = calculateMaxXP(maxXP: maxXP)
            level = levelUp(currentLevel: currentLevel)
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
            saveExperience(experienceToSave: experience ?? 0.0 , currentLevel: level ?? 0, maxXp: maximumExperience ?? 0.0)
            readyToLevelUp = true
            isReadyForMajorLevelUp(level: level ?? 0) ? majorProggression(level: level ?? 0) : nil
        } else {
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
            saveExperience(experienceToSave: experience ?? 0.0 , currentLevel: level ?? 0, maxXp: maxXP)
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
    func majorProggression(level: Int) {
        #warning("add here a logic for leveling up")
        skillPoint.addSkillPoint(skill: 1)
    }
    func isReadyForMajorLevelUp(level: Int) -> Bool {
        coins.addCoins(amount: 100)
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
    
    func playSound(soundName:String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

