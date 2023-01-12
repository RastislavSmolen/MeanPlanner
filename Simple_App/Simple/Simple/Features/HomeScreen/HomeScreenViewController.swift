//
//  ViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import UIKit
import CoreData



class HomeScreenViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var proggressView: UIProgressView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var currentTasksTableView: UITableView!
    @IBOutlet weak var proggresViewLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    // MARK: - Variables
    var viewModel : HomeScreenViewModel!
    var isEmpty :  Bool {
        return tasks.count == 0 ? true : false
    }
    var tasks: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    
    let userDefaults = UserDefaults.standard
    var maxProggress: Float = 350
    var currentLevel: Int = 1
    
    let levelUp = LvlUp()
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        proccesFethcingExperience()
        fetchCoreData()
        setup()
    }
  
    func fetchCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
            tasks = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        currentTasksTableView.reloadData()
    }
    
}

extension HomeScreenViewController {
    
    func setup() {
        proggressView.transform = CGAffineTransform(scaleX: 1, y: 4)
        
        if #available(iOS 13.0, *) {
            let addMoreBarButton = UIBarButtonItem(image: .add , style: .plain, target: self, action: #selector(addGoalAction))
            addMoreBarButton.tintColor = .white
            navigationItem.rightBarButtonItem = addMoreBarButton
        } else {
            // Fallback on earlier versions
        }
        
        userImageView.layer.cornerRadius = 100
        currentTasksTableView.dataSource = self
        currentTasksTableView.delegate = self
    }
    
    @objc func addGoalAction() {
        viewModel.navigateTo(delegate: self)
    }
}

//MARK: - Table View setup
extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmpty ? 1 : tasks.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Done") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsDone(index: indexPath)
            completionHandler(true)
        }
        
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell()}
        
        isEmpty ? cell.configureEmptyCell() : cell.configureTaskCell(task: tasks[indexPath.row])
        
        return cell
        
    }
}
// MARK: Experience Logic
extension HomeScreenViewController {
    
    func calculateExpertience(maxExperience: Float,adddedExperience: Float) -> Float {
        // Fetch experience from user defaults
        let currentExperience = fetchExperience()
        // Calculate experience adding currentExperience from userDefaults with addedExperince from cell
        let resultingExperience = currentExperience + adddedExperience
        // Save resulting experience into User defaults
        userDefaults.setValue(resultingExperience, forKey: "experience")
        // Return result
        return resultingExperience
    }
    
    func convertedExperience(experience: Float,maxExperience: Float)-> Float {
        // For correct display of the proggress view we have to divide N/M = R
        let convertedExperience = experience / maxExperience
        
        return convertedExperience
    }
    
    func saveExperience(experienceToSave: Float,currentLevel: Int, maxProggress: Float) {
        userDefaults.setValue(experienceToSave, forKey: "experience")
        userDefaults.setValue(currentLevel, forKey: "currentLevel")
        userDefaults.setValue(maxProggress, forKey: "maxProggress")

    }
    
    func fetchExperience() ->Float {
        return userDefaults.float(forKey: "experience")
    }
    func fetchLevel() ->Int {
        return userDefaults.integer(forKey: "currentLevel")
    }
    func fetchProggress() ->Float {
        return userDefaults.float(forKey: "maxProggress")
    }
    func calculateLevelProgress(experience: Float) {
        levelUp.processProgress(maxProgress: maxProggress, currentProgress: experience, currentLevel: currentLevel)
        saveExperience(experienceToSave: levelUp.currentProgress ?? 0.0,currentLevel: levelUp.level ?? 0, maxProggress: levelUp.currentProgress ?? 0.0)
    }
    func proccesFethcingExperience() {
        currentLevel = fetchLevel()
        maxProggress = fetchProggress()
        var experience = fetchExperience()
        calculateLevelProgress(experience: experience)
        experience = fetchExperience()
        proggressView.setProgress(convertedExperience(experience: experience, maxExperience: maxProggress), animated: true)
        proggresViewLabel.text = "\(Int(experience)) / \(Int(maxProggress))"
        levelLabel.text = "\(levelUp.level ?? 0 ).LVL"
    }
    func processSavingExperience (index: IndexPath) {
        //Value from list of experience
        let addedExperience =  Float(tasks[index.row].value(forKey: "reward")as! Int)
        //Calculate experience
        let experience = calculateExpertience(maxExperience: maxProggress, adddedExperience: addedExperience)
        //Set progress based on converted experience
        proggressView.setProgress(convertedExperience(experience: experience, maxExperience: maxProggress), animated: true)
        //Save experience to user defaults
        saveExperience(experienceToSave: experience, currentLevel: currentLevel, maxProggress: maxProggress)
        // Set label from results
        proggresViewLabel.text = "\(Int(experience)) / \(Int(maxProggress))"
    }
    
    private func handleMarkAsDone(index: IndexPath) {
        processSavingExperience(index: index)
        deleteFromCoreData(indexPath: index)
        proccesFethcingExperience()
    }
}
// MARK: - Delegate
extension HomeScreenViewController: Updator {
    
    func updateData() {
        fetchCoreData()
    }
    
}

//MARK: - CORE DATA
extension  HomeScreenViewController {
    
    func deleteFromCoreData(indexPath: IndexPath) {
        
        let task = tasks[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(task)
        tasks.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        fetchCoreData()
    }
}

//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let archive = UIContextualAction(style: .normal,
//                                         title: "Archive") { [weak self] (action, view, completionHandler) in
//            self?.handleMoveToArchive()
//            completionHandler(true)
//        }
//        archive.backgroundColor = .systemGreen
//
//
//        let trash = UIContextualAction(style: .destructive,
//                                       title: "Trash") { [weak self] (action, view, completionHandler) in
//            self?.handleMoveToTrash()
//            completionHandler(true)
//        }
//        trash.backgroundColor = .systemRed
//
//
//        let unread = UIContextualAction(style: .normal,
//                                        title: "Mark as Unread") { [weak self] (action, view, completionHandler) in
//            self?.handleMarkAsUnread()
//            completionHandler(true)
//        }
//        unread.backgroundColor = .systemOrange
//
//        let configuration = UISwipeActionsConfiguration(actions: [trash, archive, unread])
//
//        return configuration
//    }
//    private func handleMarkAsUnread() {
//        print("Marked as unread")
//    }
//
//    private func handleMoveToTrash() {
//        print("Moved to trash")
//    }
//
//    private func handleMoveToArchive() {
//        print("Moved to archive")
//    }
