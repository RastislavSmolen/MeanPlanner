//
//  TestViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 19/01/2023.
//

import Foundation
class TestViewModel {
    
    weak var coordinator : AppCoordinator!
    
    func navigateTo(delegate : TestViewController) {
        coordinator?.navigateTest(delegate: delegate)
    }
 
}
