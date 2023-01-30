//
//  SkillTreeViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataPasser{
    func passData(data: NSManagedObject,indexPath: IndexPath)
}
class SkillTreeViewController : UIViewController {
    
    @IBOutlet weak var skillPointAvailableLabel: UILabel!
    var viewModel : SkillTreeViewModel!
    var delegate: Updator?
    var coreDataDelegate: CoreDataPasser?
    let skillPoint = SkillPoints()
    var isEmpty :  Bool {
        return skills.count == 0 ? true : false
    }
    @IBOutlet weak var addSkillButton: UIButton!
    
    var skills: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    
    var index = IndexPath()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        
        skillPointAvailableLabel.text = "Skill points: \(skillPoint.fetchSkillPoints())"
        skillPoint.isSkillPointAvailable() ? hideButton(true): hideButton(false)
        fetchSkillFromCoreData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.updateData()
    }
    func hideButton(_ bool: Bool) {
        addSkillButton.isEnabled = bool
    }
    @IBAction func addSkillButtonAction(_ sender: Any) {
        viewModel?.navigateToCreateSkill(delegate: self)
    }
}
//MARK: - Table View
extension SkillTreeViewController : UITableViewDelegate, UITableViewDataSource  {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

             coreDataDelegate?.passData(data: skills[indexPath.row],indexPath: indexPath)
             self.dismiss(animated: true)
    }
    
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
        
        isEmpty ? cell.configureEmptyCell() : cell.configureSkillCell(skill: skills[indexPath.row])
        
        return cell
        
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(index: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        return  isEmpty ? nil : UISwipeActionsConfiguration(actions: [trash])
        
    }
    
    private func handleMoveToTrash(index: IndexPath) {
        deleteSkillFromCoreData(indexPath: index)
        tableView.reloadData()
    }
}
//MARK: - CoreData
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

extension SkillTreeViewController: Updator {
    
     func updateData() {
         skillPoint.isSkillPointAvailable() ? hideButton(true): hideButton(false)
         skillPointAvailableLabel.text = "Skill points:\(skillPoint.fetchSkillPoints())"
         fetchSkillFromCoreData()
         tableView.reloadData()
       
    }

}
