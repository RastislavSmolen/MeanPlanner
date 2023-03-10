//
//  CoordinatorProtocol.swift
//  Simple
//
//  Created by Rastislav Smolen on 08/08/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
