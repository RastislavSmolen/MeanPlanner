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
    
   public func performAction (result: String ) {
        
    }
}
