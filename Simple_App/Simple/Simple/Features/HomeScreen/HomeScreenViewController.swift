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
    
#warning("user default only for testing purposes")
    let userDefaults = UserDefaults.standard
    
    let levelUp = LevelUp()
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //        userDefaults.setValue(10, forKey: "experience")
        //        userDefaults.setValue(1, forKey: "currentLevel")
        //        userDefaults.setValue(100, forKey: "maxXp")
        setupXp()
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
    func setupXp() {
        levelUp.loadXp()
        guard let level = levelUp.level , let xp = levelUp.experience, let maxXp = levelUp.maximumExperience else { return }
        setupView(level: level, xp: xp, maxXp: maxXp)
        
    }
    func setupView(level: Int, xp: Float, maxXp: Float) {
        proggresViewLabel.text = ("\(Int(xp)) / \(Int(maxXp))")
        proggressView.setProgress(levelUp.convertedXP(xp: xp, maxXP: maxXp), animated: true)
        levelLabel.text = ("\(level).lvl")
    }
    func proccesXp(newXp: Float) {
        guard let level = levelUp.level, let maxXp = levelUp.maximumExperience else { return }
        levelUp.processXP(maxXP: maxXp, currentXP: newXp, currentLevel: level)
    }
    func saveXp(index: IndexPath) {
        let rewardXp =  Float(tasks[index.row].value(forKey: "reward")as! Int)
        let newXp = rewardXp + (levelUp.experience ?? 999999.9999)
        proccesXp(newXp: newXp)
        guard let level = levelUp.level , let xp = levelUp.experience, let maxXp = levelUp.maximumExperience else { return }
        levelUp.saveExperience(experienceToSave: xp, currentLevel: level, maxXp: maxXp)
        setupView(level: level, xp: xp, maxXp: maxXp)
    }
    
    private func handleMarkAsDone(index: IndexPath) {
        saveXp(index: index)
        deleteFromCoreData(indexPath: index)
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
