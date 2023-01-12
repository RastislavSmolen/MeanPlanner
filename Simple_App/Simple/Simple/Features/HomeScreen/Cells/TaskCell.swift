//
//  TaskCell.swift
//  Simple
//
//  Created by Rastislav Smolen on 26/08/2022.
//

import Foundation
import UIKit
import CoreData

class TaskCell: UITableViewCell  {
    
    @IBOutlet weak var taskCellBackground: UIView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskInfo: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func changeCellBehavior(isComplete: Bool) {
        
    }
    func configureEmptyCell() {
        taskName.text = "Please Create new Task"
        taskCellBackground.backgroundColor = .lightGray
        rewardLabel.isHidden = true
        isUserInteractionEnabled = false
    }
    
    func configureTaskCell(task: NSManagedObject?) {
        
        guard let name = task?.value(forKey: "taskName") as? String,
              let reward = task?.value(forKey: "reward") as? Int ,
              let color = task?.value(forKey: "taskColor") as? String
        else { return }
        
        taskName.text = name
        taskCellBackground.backgroundColor = UIColor(hex: color)
        rewardLabel.isHidden = false
        isUserInteractionEnabled = true
        rewardLabel.text = "\(reward) XP"
    }
}

