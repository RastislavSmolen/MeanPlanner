//
//  SkillTreeViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
import UIKit
import CoreData

class SkillTreeViewController : UIViewController {
    
    var viewModel : SkillTreeViewModel!
    
    var isEmpty :  Bool {
        return skills.count == 0 ? true : false
    }
    
    var skills: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveSkillToCoreData(skillName: "Archery", skillLevel: 1, skillXP: 100.00, skillMaxXP: 1000.00)
        fetchSkillFromCoreData()
        viewModel = SkillTreeViewModel()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // tableView
    // add Cells
    // if no cells then tableView is empty
    // limit how many skill can be added
    // add button to the cell
    // when button tapped then add skill
    // if skillPoints are empty dont enable the button
    
    // cell
    // level of the skill
    // experience of the skill
    // button to level up the skill
    // delete skill
    // skill proggress view
    
    // back button when tapped it will go to the home view controller and it will remove skillpoint if used any
}
extension SkillTreeViewController : UITableViewDelegate, UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmpty ? 1 : skills.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell") as? SkillCell else { return UITableViewCell()}
        
        isEmpty ? cell.configureEmptyCell() : cell.configureTaskCell(skill: skills[indexPath.row])
        
        return cell
        
    }
}
extension  SkillTreeViewController {
    
    func fetchSkillFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Skill")
        do {
            skills = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        tableView.reloadData()
    }
    
    func deleteSkillFromCoreData(indexPath: IndexPath) {
        
        let skill = skills[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(skill)
        skills.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
            skills.append(skill)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        fetchSkillFromCoreData()
    }
    
    func saveSkillToCoreData(skillName: String, skillLevel: Int,skillXP: Float, skillMaxXP: Float) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Skill",in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(skillName, forKeyPath: "skillName")
        task.setValue(skillLevel, forKeyPath: "skillLevel")
        task.setValue(skillXP, forKeyPath: "skillCurrentXP")
        task.setValue(skillMaxXP, forKeyPath: "skillMaxXP")
        
        do {
            try managedContext.save()
            skills.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
