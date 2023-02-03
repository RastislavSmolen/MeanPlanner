//
//  StatisticsViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 31/01/2023.
//

import Foundation
import UIKit
class StatisticsViewController : UIViewController {
    var delegate : Updator?
    var viewModel : StatisticsViewModel!
    let globalUserDataSystem = GlobalLevelUpSystem()

    @IBOutlet weak var physicalPercentageLabel: UILabel!
    @IBOutlet weak var balancerProggresView: UIProgressView!
    @IBOutlet weak var mentalPercentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(hex: "ffffff")
        setupBalancer()
    }
    func setupBalancer(){
       let physicalValue = globalUserDataSystem.fetchUserData(kind: .integer, forkey: .physical) as! Int
       let mentalValue = globalUserDataSystem.fetchUserData(kind: .integer, forkey: .mental) as! Int
        let numbers = viewModel.calculateBarValue(mental: Double(mentalValue), physical: Double(physicalValue))
        mentalPercentageLabel.text = "\(numbers.0)%"
        physicalPercentageLabel.text = "\(numbers.1)%"
        balancerProggresView.progress = Float(numbers.0 / 100)
    }
}
