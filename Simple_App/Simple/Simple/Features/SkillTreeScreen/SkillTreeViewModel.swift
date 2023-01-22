//
//  SkillTreeViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
class SkillTreeViewModel {
    weak var coordinator :  AppCoordinator!
    
    func navigateToHome() {
        coordinator?.navigateToHomeScreenPage()
    }
    func navigateToCreateSkill(delegate: SkillTreeViewController) {
        coordinator?.navigateToCreateSkill(delegate: delegate)
    }
    func navigateToAddGoal(delegate: SkillTreeViewController) {
        coordinator?.toAddGoal(delegate: delegate)
    }
   public func performAction (result: String ) {
        
    }
}
