//
//  ViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import UIKit
import CoreData

final class HomeScreenViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var proggressView: UIProgressView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var currentTasksTableView: UITableView!
    @IBOutlet weak var proggresViewLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var detailTaskView: UIView!
    @IBOutlet weak var detailTaskNameLabel: UILabel!
    @IBOutlet weak var closeDetailViewButton: UIButton!
    @IBOutlet weak var detailTaskXpLabel: UILabel!
    @IBOutlet weak var infoDetailViewLabel: UILabel!
    @IBOutlet weak var finishTaskView: UIButton!
    
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var addViewButton: KButton!
    @IBOutlet weak var totalTasksLabel: UILabel!
    @IBOutlet weak var easyTaskLabel: UILabel!
    @IBOutlet weak var normalTaskLabel: UILabel!
    @IBOutlet weak var hardTaskLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var skillPointButton: UIButton!
    // MARK: - Variables
    @IBOutlet weak var closingButton: UIButton!
    //MARK: - Models
    var viewModel: HomeScreenViewModel!
    let levelUp = LevelUp()
    let availableTasks = AvailableTask()
    let firework = Firework()
    let skillPoints = SkillPoints()
    let coins = Coins()

    
    var isEmpty :  Bool {
        return tasks.count == 0 ? true : false
    }
    var tasks: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
#warning("user default only for testing purposes")
#warning("move all user defaults to same place for better management")
    let userDefaults = UserDefaults.standard
    
    //MARK: Animation variables and constants
    var displayLink: CADisplayLink?
    let animationDuration: Double = 0.3
    var animationStartDate = Date()
    var oldXp = Float()
    var elapsedTime = TimeInterval()
    private var startTime = 0.0
    var index = IndexPath()
    
    let notification = Notification.Name("Leaving.Shop")

    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.setValue(10, forKey: "experience")
        userDefaults.setValue(1, forKey: "currentLevel")
        userDefaults.setValue(100, forKey: "maxXp")
        
        availableTasks.saveTasks(difficulty: .easy, amountLeft: 3)
        availableTasks.saveTasks(difficulty: .normal, amountLeft: 2)
        availableTasks.saveTasks(difficulty: .hard, amountLeft: 1)

        availableTasks.setMaxAmountForTasks(difficulty: .easy ,maxAmount: 3)
        availableTasks.setMaxAmountForTasks(difficulty: .normal ,maxAmount: 2)
        availableTasks.setMaxAmountForTasks(difficulty: .hard ,maxAmount: 1)
        skillPoints.saveSkillPoints(point: 0)
        coins.saveCoins(coins: 0 )
        
        addObserver()
  
        
        
        let skill = skillPoints.fetchSkillPoints()
        skillPointButton.setTitle("Skill Points: \(skill)", for: .normal)
        let coins =  coins.fetchCoins()
        balance.text = "Balance: \(coins)"
        availableTasks.fetchAllAlvailableTasks()
        availableTasks.fetchAllMaxTasks()
        setupXp()
        fetchCoreData()
        setupUI()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self]  notification in
            guard let balance = self?.coins.fetchCoins(),let skill = self?.skillPoints.fetchSkillPoints() else { return }
            self?.balance.text = "Balance: \(balance)"
            self?.skillPointButton.setTitle("Skill Points: \(skill)", for: .normal)

        }
    }

    @IBAction func didTapClosingSection(_ sender: Any) {
        if !detailTaskView.isHidden {
            configureDetailView(isHidden: true)
        }
    }
    @IBAction func addTaskAction(_ sender: Any) {
        addGoalAction()
    }
    @IBAction func didTapCloseDetailViewButton(_ sender: Any) {
        configureDetailView(isHidden: true)
    }
    @IBAction func didTapFinnishDetailViewButton(_ sender: Any) {
        handleMarkAsDone(index: index)
    }
    @IBAction func skillPointButtonAction(_ sender: Any) {
        viewModel.navigateToSkillTreeViewController(delegate: self)
    }
    @IBAction func shopButtonAction(_ sender: Any) {
        viewModel.navigateToShopViewController(delegate: self)
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
    
    func countAvalableTasks() -> String {
        let easy = availableTasks.fetchAvailableTasks(difficulty: .easy)
        let normal = availableTasks.fetchAvailableTasks(difficulty: .normal)
        let hard = availableTasks.fetchAvailableTasks(difficulty: .hard)
        let countOfTask = easy + normal + hard
        return "\(countOfTask)"
    }

    func setupUI() {
        totalTasksLabel.text = "Total: \(countAvalableTasks())"
        easyTaskLabel.text = "Easy: \(availableTasks.easyTasks)"
        normalTaskLabel.text = "Normal: \(availableTasks.normalTasks)"
        hardTaskLabel.text = "Hard: \(availableTasks.hardTasks)"
        proggressView.transform = CGAffineTransform(scaleX: 1, y: 2)
    
        configureDetailView(isHidden: true)
        
        userImageView.layer.cornerRadius = 100
        currentTasksTableView.dataSource = self
        currentTasksTableView.delegate = self
    }
    
    func addGoalAction() {
        availableTasks.areTasksEmpty() ? nil : viewModel.navigateToAddTaskViewController(delegate: self)
    }
    func configureDetailView(isHidden: Bool) {
        detailTaskView.isHidden = isHidden
        closingButton.isHidden = isHidden
    }
    
}

//MARK: - Animation
extension HomeScreenViewController  {
    
    func fireworkAnimation(){
        firework.fireworkAnimation(view: self.view)
    }
    @objc func runAnimation() {
        let elapsedTime = CACurrentMediaTime() - startTime
        if elapsedTime > animationDuration {
            stopDisplayLink()
        } else {
            let newXp = levelUp.fetchXP()
            let maxValue = levelUp.fetchMaxXp()
            let percentage = elapsedTime / animationDuration
            let value = oldXp + Float(percentage) * (newXp - oldXp)
            self.proggresViewLabel.text = ("\(Int(value)) / \(Int(maxValue))")
        }
        
    }
    
    func xpCounterAnimation() {
        let now = Date()
        elapsedTime = now.timeIntervalSince(animationStartDate)
        
        stopDisplayLink()
        startTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(runAnimation))
        displayLink?.preferredFramesPerSecond = 0
        displayLink?.add(to: .main, forMode: .default)
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
}
//MARK: - Table View setup
extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureDetailView(isHidden: false)
        setupUIForDetailView(index: indexPath)
        index = indexPath
    }
    func setupUIForDetailView(index: IndexPath) {
        guard let colorHex = tasks[index.row].value(forKey: "taskColor") as? String,
              let name = tasks[index.row].value(forKey: "taskName") as? String,
              let reward = tasks[index.row].value(forKey: "reward")as? Int,
              let info = tasks[index.row].value(forKey: "taskDetails") as? String
        else {return}
        
        detailTaskView.backgroundColor = UIColor(hex: colorHex)
        detailTaskXpLabel.text = "\(reward) xp "
        detailTaskNameLabel.text = name
        infoDetailViewLabel.text = info
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmpty ? 1 : tasks.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal,
                                        title: "Done") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsDone(index: indexPath)
            completionHandler(true)
        }
        
        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(index: indexPath)
            completionHandler(true)
        }
        done.backgroundColor = .systemBlue
        trash.backgroundColor = .systemRed
        
        return  isEmpty ? nil : UISwipeActionsConfiguration(actions: [done,trash])
        
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
        levelLabel.text = ("\(level)")
    }
    func proccesXp(newXp: Float) {
        guard let level = levelUp.level, let maxXp = levelUp.maximumExperience else { return }
        levelUp.processXP(maxXP: maxXp, currentXP: newXp, currentLevel: level)
    }
    func saveXp(index: IndexPath) {
        guard let xp = levelUp.experience else { return }
        let rewardXp =  Float(tasks[index.row].value(forKey: "reward")as! Int)
        let newXp = rewardXp + xp
        oldXp = xp
        proccesXp(newXp: newXp)
        setupView(level: levelUp.fetchLevel(), xp: levelUp.fetchXP(), maxXp: levelUp.fetchMaxXp())
        levelUp.loadXp()
    }
    private func handleMarkAsDone(index: IndexPath) {
        saveXp(index: index)
        filterForDifficulty(index: index)
        deleteFromCoreData(indexPath: index)
        guard let readyToLevelUp = levelUp.readyToLevelUp else { return }
        readyToLevelUp ? levelUp.playSound(soundName: "fanfare"): levelUp.playSound(soundName: "success")
        readyToLevelUp ? fireworkAnimation() : nil
        xpCounterAnimation()
        configureDetailView(isHidden: true)
        balance.text = "Balance: \(coins.fetchCoins())"
    }
        private func handleMoveToTrash(index: IndexPath) {
           filterForDifficulty(index: index)
           deleteFromCoreData(indexPath: index)
        }
    func filterForDifficulty(index: IndexPath) {
        switch tasks[index.row].value(forKey: "difficulty") as? String {
        case "easy": availableTasks.taskWasFinnished(difficulty: .easy)
            updateViews(difficulty: .easy, view: easyTaskLabel, text: "Easy")

        case "normal": availableTasks.taskWasFinnished(difficulty: .normal)
            updateViews(difficulty: .normal, view: normalTaskLabel, text: "Normal")

        case "hard": availableTasks.taskWasFinnished(difficulty: .hard)
            updateViews(difficulty: .hard, view: hardTaskLabel, text: "Hard")

            default: print("Task does not exits, check saveCoreData()")
        }
        totalTasksLabel.text = "Total: \(countAvalableTasks())"

    }
}
// MARK: - Delegate
extension HomeScreenViewController: Updator{
    
     func updateData() {
        fetchCoreData()
         totalTasksLabel.text = "Total: \(countAvalableTasks())"
         updateViews(difficulty: .easy, view: easyTaskLabel, text: "Easy")
         updateViews(difficulty: .normal, view: normalTaskLabel, text: "Normal")
         updateViews(difficulty: .hard, view: hardTaskLabel, text: "Hard")
    }
    func updateViews(difficulty: Difficulty, view: UILabel,text: String) {
        view.text = "\(text): \(availableTasks.fetchAvailableTasks(difficulty: difficulty))"
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

