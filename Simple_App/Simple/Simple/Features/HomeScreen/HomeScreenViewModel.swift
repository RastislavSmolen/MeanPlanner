//
//  HomeScreenViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 07/08/2022.
//

import Foundation
import CoreData

class HomeScreenViewModel {

    weak var coordinator: AppCoordinator!
    let userDefaults = UserDefaults.standard
    let levelUp = LevelUp()
    let levelUpSkill = LevelUpSkill()
    let availableTasks = AvailableTask()
    let firework = Firework()
    let skillPoints = SkillPoints()
    let coins = Coins()
    let coreData = CoreDataSystem()
    let alert = Alert()
    let todaysDate = NSDate()
    let globalUserDataSystem = GlobalLevelUpSystem()
    var tasks: [NSManagedObject] = []
    var skills: [NSManagedObject] = []
    
    func navigateToAddTaskViewController(delegate: HomeScreenViewController) {
        coordinator?.navigateToAddGoalViewController(delegate: delegate)
    }
    func navigateToSkillTreeViewController(delegate: HomeScreenViewController) {
        coordinator.navigateToSkillTree(delegate: delegate)
    }
    func navigateToShopViewController(delegate: HomeScreenViewController) {
        coordinator.navigateToShop(delegate: delegate)
    }
    func navigateToStatistics(delegate: HomeScreenViewController) {
        coordinator.toStatistics(delegate: delegate)
    }
    func navigateToSettings(delegate: HomeScreenViewController) {
        coordinator.toSettings(delegate: delegate)
    }
    
    func resetEverything() {
        userDefaults.setValue(10, forKey: "experience")
        userDefaults.setValue(1, forKey: "currentLevel")
        userDefaults.setValue(100, forKey: "maxXp")
        
        availableTasks.saveTasks(difficulty: .easy, amountLeft: 0)
        availableTasks.saveTasks(difficulty: .normal, amountLeft: 0)
        availableTasks.saveTasks(difficulty: .hard, amountLeft: 0)
        
        globalUserDataSystem.saveUserData(forkey: .mental, itemToSave: 0)
        globalUserDataSystem.saveUserData(forkey: .physical, itemToSave: 0)
        skillPoints.saveSkillPoints(point: 2)
        coins.saveCoins(coins: 3000)
    }
}
