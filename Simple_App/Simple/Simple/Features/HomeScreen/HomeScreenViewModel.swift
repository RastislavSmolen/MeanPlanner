//
//  HomeScreenViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 07/08/2022.
//

import Foundation

class HomeScreenViewModel {
    
    weak var coordinator : AppCoordinator!
    
    func navigateTo(delegate : HomeScreenViewController) {
        coordinator?.navigateToAddGoalViewController(delegate: delegate)
    }
}
