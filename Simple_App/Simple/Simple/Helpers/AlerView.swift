//
//  AlerView.swift
//  Simple
//
//  Created by Rastislav Smolen on 25/01/2023.
//

import Foundation
import UIKit
class Alert {
    let coins = Coins()
    func showMaxCapacityReachedAlert(forTask: String,controller: UIViewController) {
        let alert = UIAlertController(title: "Maximum \(forTask) tasks reached", message: "Finnish some tasks and come back", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
            controller.present(alert, animated: true, completion: .none)
        }
    func showTrashAlert(controller: UIViewController,completion:@escaping ()-> Void) {
        let alert = UIAlertController(title: "Are you sure you want trash this task", message: "It will cost you 500 coins", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            completion()
            }))
            controller.present(alert, animated: true, completion: .none)
        }
    
    func notEnougCoinsAlert(controller: UIViewController) {
        let alert = UIAlertController(title: "You dont have enough coins", message: "You dont have enough coins, finnish some task and try again", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        controller.present(alert, animated: true, completion: .none)
    }
    
    func buyItemAlert(controller: UIViewController,itemName:String,cost: Int,completion: @escaping ()-> Void) {
        let alert = UIAlertController(title: "Are you sure you want to buy this item", message: "You are buying \(itemName) for \(cost) coins", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        completion()
        }))
        controller.present(alert, animated: true, completion: .none)
    }
    func itemPurchasedAlert(controller: UIViewController,itemName:String,cost: Int,completion: @escaping ()-> Void) {
        let alert = UIAlertController(title: "Purchased", message: "You purchased \(itemName) for \(cost) coins", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Continue Shopping",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Leave Shop",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            completion()
        }))
        controller.present(alert, animated: true, completion: .none)
    }
}

