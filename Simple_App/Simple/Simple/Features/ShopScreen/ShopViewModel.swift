//
//  ShopViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
class ShopViewModel {
    
    weak var coordinator :  AppCoordinator!
    
    func navigateToHome() {
        coordinator?.navigateToHomeScreenPage()
    }
    
   public func performAction (result: String ) {
        
    }
}
