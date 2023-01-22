//
//  SkillCell.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
import UIKit
import CoreData

class SkillCell: UITableViewCell {
    @IBOutlet weak var skillProggresionView: UIView!
    @IBOutlet weak var skillExperience: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillLevelLabel: UILabel!
    @IBOutlet weak var proggressionView: UIProgressView!
    let levelUp = LevelUp()
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureEmptyCell() {
        skillLevelLabel.text = "No Skills available.Please create new skill"
        skillProggresionView.backgroundColor = .lightGray
        skillName.isHidden = true
        proggressionView.isHidden = true
        skillExperience.isHidden = true
        isUserInteractionEnabled = false
    }
    
    func configureSkillCell(skill: NSManagedObject?) {
        
        skillProggresionView.backgroundColor = .white
        skillName.isHidden = false
        proggressionView.isHidden = false
        skillExperience.isHidden = false
        isUserInteractionEnabled = true
        guard let name = skill?.value(forKey: "skillName") as? String,
              let experience = skill?.value(forKey: "skillCurrentXP") as? Float,
              let maxSkillExperience = skill?.value(forKey: "skillMaxXP") as? Float,
              let level = skill?.value(forKey: "skillLevel") as? Int
        else { return }
        
        let skillXP = Int(experience)
        let skillMaxXP = Int(maxSkillExperience)
        let proggression = levelUp.convertedXP(xp: Float(skillXP), maxXP: Float(skillMaxXP))
        skillName.text = name
        skillExperience.text = "\(skillXP) / \(skillMaxXP)"
        skillLevelLabel.text = "\(level)"
        proggressionView.progress = proggression
        
    }
}
