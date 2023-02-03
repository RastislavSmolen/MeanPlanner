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
        let numbers = viewModel.calculateBarValue(mental: 150, physical: 60)
        mentalPercentageLabel.text = "\(numbers.0)%"
        physicalPercentageLabel.text = "\(numbers.1)%"
        balancerProggresView.progress = Float(numbers.0 / 100)
    }
}
