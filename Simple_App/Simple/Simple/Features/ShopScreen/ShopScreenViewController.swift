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
    
    var delegate: ShopDelegate?
    var updateClosure: (() -> Void)?

    var viewModel: ShopViewModel!
    let coins = Coins()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.update()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("test"), object: nil)
        updateClosure?()
    }
    @IBAction func skillItemButton(_ sender: Any) {
        coins.buy(cost: 549, item: .skill)
    }
}
