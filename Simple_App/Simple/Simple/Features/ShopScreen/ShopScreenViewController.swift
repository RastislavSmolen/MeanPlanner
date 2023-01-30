//
//  ShopScreenViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
import UIKit

protocol ShopDelegate {
    func update()
}
class ShopViewController: UIViewController {
    //MARK: - Skill Item
    @IBOutlet weak var skillItemLabel: UIView!
    @IBOutlet weak var skillItemDescription: UILabel!
    @IBOutlet weak var skillItemCost: UILabel!
    @IBOutlet weak var skillContainerView: UIView!
    @IBOutlet weak var skillBuyButton: UIButton!
    
    var delegate: ShopDelegate?

    var viewModel: ShopViewModel!
    let coins = Coins()
    let alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillContainerView.layer.borderColor = UIColor(hex: "ae29d3").cgColor
        skillContainerView.layer.borderWidth = 2
        skillContainerView.layer.cornerRadius = 10
        skillBuyButton.layer.cornerRadius = 10
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.update()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    @IBAction func skillItemButton(_ sender: Any) {
        alert.buyItemAlert(controller: self, itemName: "Skill", cost: 549, completion: {
            if self.coins.checkIfAbleToBuy(cost: 549) {
                self.coins.buy(cost: 549, item: .skill)
                self.alert.itemPurchasedAlert(controller: self, itemName: "Skill", cost: 549, completion: {
                    self.dismiss(animated: true)
                })
            } else {
                self.alert.notEnougCoinsAlert(controller: self)
            }
        })
//        alert.showTrashAlert(controller: self, completion: {
//            if  self.coins.checkIfAbleToBuy(cost: 500) {
//                self.coins.spend(cost: 500)
//                self.balance.text = "Balance: \(self.coins.fetchCoins())"
//                self.filterForDifficulty(index: index)
//                self.deleteDesiredStack(indexPath: index, entityName: .Task, dataStack: self.tasks)
//            } else {
//                self.alert.notEnougCoinsAlert(controller: self)
//            }
//        })
//        coins.buy(cost: 549, item: .skill)
    }
}
