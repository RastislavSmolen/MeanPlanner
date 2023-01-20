//
//  AppCoordinator.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)

    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        // The first time this coordinator started, is to launch login page.
        createToHomeScreenPage()
    }
    
}
extension AppCoordinator {
    
    func createToHomeScreenPage() {
        // Instantiate LoginViewController
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        // Instantiate LoginViewModel
        let homeViewModel = HomeScreenViewModel.init()
        // Set the Coordinator to the ViewModel
        homeViewModel.coordinator = self
        // Set the ViewModel to ViewController
        homeViewController.viewModel = homeViewModel
        // Push it.
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func navigateToAddGoalViewController () {
        // Instantiate LoginViewController
        let addGoalViewController = storyboard.instantiateViewController(withIdentifier: "AddGoalViewController") as! AddGoalViewController
        // Instantiate LoginViewModel
        let addGoalViewModel = AddGoalViewModel.init()
        // Set the Coordinator to the ViewModel
        addGoalViewModel.coordinator = self
        // Set the ViewModel to ViewController
        addGoalViewController.viewModel = addGoalViewModel
        // Push it.
        navigationController.pushViewController(addGoalViewController, animated: true)
    }
    func navigateToHomeScreenPage() {
        // Instantiate LoginViewController
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        // Instantiate LoginViewModel
        let homeViewModel = HomeScreenViewModel.init()
        // Set the Coordinator to the ViewModel
        homeViewModel.coordinator = self
        // Set the ViewModel to ViewController
        homeViewController.viewModel = homeViewModel
        // Push it.
        navigationController.present(homeViewController, animated: true)
    }
    
    func navigateToAddGoalViewController(delegate: HomeScreenViewController) {
        // Instantiate LoginViewController
        let addGoalViewController = storyboard.instantiateViewController(withIdentifier: "AddGoalViewController") as! AddGoalViewController
        // Instantiate LoginViewModel
        let addGoalViewModel = AddGoalViewModel.init()
        // Set the Coordinator to the ViewModel
        addGoalViewModel.coordinator = self
        // Set the ViewModel to ViewController
        addGoalViewController.viewModel = addGoalViewModel
        // Push it.
        addGoalViewController.delegate = delegate
        
        navigationController.present(addGoalViewController, animated: true)
    }
    func dissmisAddGoalViewController() {
        // Instantiate LoginViewController
        let addGoalViewController = storyboard.instantiateViewController(withIdentifier: "AddGoalViewController") as! AddGoalViewController
        // Instantiate LoginViewModel
        let addGoalViewModel = AddGoalViewModel.init()
        // Set the Coordinator to the ViewModel
        addGoalViewModel.coordinator = self
        // Set the ViewModel to ViewController
        addGoalViewController.viewModel = addGoalViewModel
        // Dissmiss it.
        navigationController.dismiss(animated: true)
    }
    func navigateToSkillTree(delegate: HomeScreenViewController) {
        // Instantiate LoginViewController
        let skillTreeViewController = storyboard.instantiateViewController(withIdentifier: "SkillTreeViewController") as! SkillTreeViewController
        // Instantiate LoginViewModel
        let skillTreeViewModel = SkillTreeViewModel.init()
        // Set the Coordinator to the ViewModel
        skillTreeViewModel.coordinator = self
        // Set the ViewModel to ViewController
        skillTreeViewController.viewModel = skillTreeViewModel
        // Push it.
       // testViewController.delegate = delegate
        navigationController.present(skillTreeViewController, animated: true)
    }
    func dissmissSkillTreeViewController() {
        // Instantiate LoginViewController
        let skillTreeViewController = storyboard.instantiateViewController(withIdentifier: "SkillTreeVieController") as! SkillTreeViewController
        // Instantiate LoginViewModel
        let skillTreeViewModel = SkillTreeViewModel.init()
        // Set the Coordinator to the ViewModel
        skillTreeViewModel.coordinator = self
        // Set the ViewModel to ViewController
        skillTreeViewController.viewModel = skillTreeViewModel
        // Push it.
       // testViewController.delegate = delegate
        navigationController.dismiss(animated: true)
    }
}
