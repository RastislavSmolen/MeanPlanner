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
            isReadyForMajorLevelUp(level: level ?? 0) ? majorProggression(level: level ?? 0) : nil
            updateCoreDataOfSkill(skillName: skillName, skillLevel: level ?? 0, skillXP: experience ?? 0.0, skillMaxXP: maximumExperience ?? 0.0, index: index)
        } else {
            experience = calculateNewXP(currentXP: currentXP, maxXP: maxXP)
            updateCoreDataOfSkill(skillName: skillName, skillLevel: currentLevel , skillXP: experience ?? 0.0 , skillMaxXP: maxXP , index: index)
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
        print("new skill point added")
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
    
    func updateCoreDataOfSkill(skillName: String, skillLevel: Int,skillXP: Float, skillMaxXP: Float,index: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        
      
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let results = results else { return }
            results[index].setValue(skillName, forKeyPath: "skillName")
            results[index].setValue(skillLevel, forKeyPath: "skillLevel")
            results[index].setValue(skillXP, forKeyPath: "skillCurrentXP")
            results[index].setValue(skillMaxXP, forKeyPath: "skillMaxXP")
           
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try managedContext.save()
           }
        catch {
                print("Saving Core Data Failed: \(error)")
            }
        }
    }


