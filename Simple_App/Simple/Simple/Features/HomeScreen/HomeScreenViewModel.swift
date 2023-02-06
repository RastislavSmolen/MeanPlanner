//
//  HomeScreenViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 07/08/2022.
//

import Foundation

class HomeScreenViewModel {

    weak var coordinator: AppCoordinator!
    
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
}
