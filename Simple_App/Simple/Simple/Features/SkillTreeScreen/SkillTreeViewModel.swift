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
    
   public func performAction (result: String ) {
        
    }
}
