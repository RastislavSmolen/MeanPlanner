//
//  CreateSkillViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 22/01/2023.
//

import Foundation
import UIKit
import CoreData

class CreateSkillViewController : UIViewController {
    
    var viewModel : CreateSkillViewModel!
    var delegate : Updator?
    var skills: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    let skillLevel = 1
    let skillXp = 0
    let skillMaxXp = 100
    let skillPoint = SkillPoints()
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var skillNameTextField: UITextField!
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        createButton.layer.cornerRadius = 10
        skillNameTextField.backgroundColor = .clear
        skillNameTextField.layer.cornerRadius = 10
        skillNameTextField.layer.borderWidth = 2
        skillNameTextField.layer.borderColor = UIColor(hex: "ae29d3").cgColor
        skillNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Piano",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }

    @IBAction func createSkillButtonAction(_ sender: Any) {
        guard let skillName = skillNameTextField.text else { return }
        saveSkillToCoreData(skillName: skillName, skillLevel: skillLevel, skillXP: skillXp, skillMaxXP: skillMaxXp)
        skillPoint.spendSkillPoint()
        delegate?.updateData()
        self.dismiss(animated: true)
    }
    
    func saveSkillToCoreData(skillName: String, skillLevel: Int,skillXP: Int, skillMaxXP: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Skill",in: managedContext)!
        let skill = NSManagedObject(entity: entity, insertInto: managedContext)
        
        skill.setValue(skillName, forKeyPath: "skillName")
        skill.setValue(skillLevel, forKeyPath: "skillLevel")
        skill.setValue(skillXP, forKeyPath: "skillCurrentXP")
        skill.setValue(skillMaxXP, forKeyPath: "skillMaxXP")
        
        do {
            try managedContext.save()
            skills.append(skill)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
