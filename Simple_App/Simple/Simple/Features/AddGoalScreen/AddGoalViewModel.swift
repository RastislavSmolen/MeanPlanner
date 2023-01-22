//
//  AddGoalViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 10/08/2022.
//

import Foundation

class AddGoalViewModel {
    
    weak var coordinator :  AppCoordinator!
    
    func navigateToHome() {
        coordinator?.navigateToHomeScreenPage()
    }
    func navigateToSkillTree(delegate: AddGoalViewController){
        coordinator?.toSkillTreeFromAddGoal(delegate: delegate)
    }
    func dissmissAddGoal() {
        coordinator?.dissmisAddGoalViewController() 
    }
    
    
   public func performAction (result: String ) {
        
    }
}
