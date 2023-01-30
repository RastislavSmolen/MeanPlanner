//
//  ViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import UIKit
import CoreData

enum State {
    case isBlocked
    case isUnblocked
}
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
    
    @IBOutlet weak var addTaskButton: KButton!
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
    let levelUpSkill = LevelUpSkill()
    let availableTasks = AvailableTask()
    let firework = Firework()
    let skillPoints = SkillPoints()
    let coins = Coins()
    let coreData = CoreDataSystem()
    let alert = Alert()
    let todaysDate = NSDate()
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
    var blurEffectView = UIVisualEffectView()

    var isEmpty :  Bool {
        return tasks.count == 0 ? true : false
    }
    var tasks: [NSManagedObject] = []
    var skills: [NSManagedObject] = []
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetEverything()
        setupXp()
        fetchDesiredStack(stack: .Task)
        setupUI()
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - IBActions
    @IBAction func didTapClosingSection(_ sender: Any) {
        if !detailTaskView.isHidden {
            configureDetailView(isHidden: true)
        }
    }
    func resetEverything() {
        userDefaults.setValue(10, forKey: "experience")
        userDefaults.setValue(1, forKey: "currentLevel")
        userDefaults.setValue(100, forKey: "maxXp")

        availableTasks.saveTasks(difficulty: .easy, amountLeft: 0)
        availableTasks.saveTasks(difficulty: .normal, amountLeft: 0)
        availableTasks.saveTasks(difficulty: .hard, amountLeft: 0)

        skillPoints.saveSkillPoints(point: 2)
        coins.saveCoins(coins: 3000)
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
}

//MARK: SETUP
extension HomeScreenViewController {
    
    func setupUI() {
        setupUiButton()
        balance.text = fetchBalance()
        
        setupTaskLabels()
        proggressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        
        configureDetailView(isHidden: true)
        
        currentTasksTableView.dataSource = self
        currentTasksTableView.delegate = self
        
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = closingButton.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.addGestureRecognizer(tap)
        closingButton.addSubview(blurEffectView)
    

    }
    func setupUiButton(){
        let skillPoint = "Skill Points: \(skillPoints.fetchSkillPoints())"
        skillPointButton.setTitle(skillPoint, for: .normal)
        skillPointButton.titleLabel?.text = skillPoint
        skillPointButton.layer.borderWidth = 1
        skillPointButton.layer.borderColor = UIColor(hex: "ae29d3").cgColor
        skillPointButton.layer.cornerRadius = 10
        skillPointButton.backgroundColor = UIColor(hex: "121212")
    }
    func setupTaskLabels(){
        let easy = availableTasks.fetchAvailableTasks(difficulty: .easy)
        let normal = availableTasks.fetchAvailableTasks(difficulty: .normal)
        let hard = availableTasks.fetchAvailableTasks(difficulty: .hard)
        let countOfTask = easy + normal + hard
        totalTasksLabel.text = "Total: \(countOfTask)"
        availableTasks.updateLabel(kind: .easy, label: easyTaskLabel)
        availableTasks.updateLabel(kind: .normal, label: normalTaskLabel)
        availableTasks.updateLabel(kind: .hard, label: hardTaskLabel)
    }
    
    func addGoalAction() {
        viewModel.navigateToAddTaskViewController(delegate: self)
    }
    func configureDetailView(isHidden: Bool) {
        detailTaskView.isHidden = isHidden
        closingButton.isHidden = isHidden
    }
    
}
// MARK: - CORE DATA
extension HomeScreenViewController: CoreDataFetcher {
    
    func fetchDesiredStack(stack: CoreDataEntity){
        switch stack {
        case .Task: tasks = coreData.fetchCoreData(entityName: .Task)
        case .Skill: skills = coreData.fetchCoreData(entityName: .Skill)
        }
        currentTasksTableView.reloadData()
    }
    func deleteDesiredStack(indexPath: IndexPath, entityName: CoreDataEntity, dataStack: [NSManagedObject]){
        tasks = coreData.deleteFromCoreData(indexPath: indexPath, entityName: entityName, dataStack: dataStack)
        currentTasksTableView.reloadData()
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
            guard let newXp = levelUp.fetchUserData(kind: .float, forkey: .experience) as? Float,
                  let maxValue = levelUp.fetchUserData(kind: .float, forkey: .maxXp) as? Float else { return }
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
        blurEffectView.isHidden = false
        setupUIForDetailView(index: indexPath)
        index = indexPath
    }
    func setupUIForDetailView(index: IndexPath) {
        guard let colorHex = tasks[index.row].value(forKey: "taskColor") as? String,
              let name = tasks[index.row].value(forKey: "taskName") as? String,
              let reward = tasks[index.row].value(forKey: "reward")as? Int,
              let info = tasks[index.row].value(forKey: "taskDetails") as? String
        else {return}
    
        closeDetailViewButton.setTitle("", for: .normal)
        finishTaskView.backgroundColor = UIColor(hex: "ae29d3")
        finishTaskView.layer.cornerRadius = 10
        detailTaskView.backgroundColor = UIColor(hex: "121212",alpha: 0)
        detailTaskView.layer.cornerRadius = 20
        detailTaskView.layer.borderWidth = 2
        detailTaskView.layer.borderColor = UIColor(hex: "ae29d3").cgColor
        detailTaskXpLabel.text = "\(reward) xp "
        detailTaskNameLabel.text = name
        infoDetailViewLabel.text = info
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        detailTaskView.isHidden = true
        closingButton.isHidden = true
        blurEffectView.isHidden = true
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
        
        guard let experience = levelUp.fetchUserData(kind: .float, forkey: .experience) as? Float,
              let maxXp = levelUp.fetchUserData(kind: .float, forkey: .maxXp) as? Float,
              let level = levelUp.fetchUserData(kind: .integer, forkey: .currentLevel) as? Int
        else { return }
        
        setupView(level: level, xp: experience, maxXp: maxXp)
        levelUp.loadXp()
    }
    
    private func handleMarkAsDone(index: IndexPath) {
        balance.text = fetchBalance()
        setupUiButton()
        saveXp(index: index)
        filterForDifficulty(index: index)
        findSkill(index: index)
        deleteDesiredStack(indexPath: index, entityName: .Task, dataStack: tasks)
        xpCounterAnimation()
        configureDetailView(isHidden: true)
        // playSound()
    }
    
    private func playSound(){
          guard let readyToLevelUp = levelUp.readyToLevelUp else { return }
                 readyToLevelUp ? levelUp.playSound(soundName: "fanfare"): levelUp.playSound(soundName: "success")
                 readyToLevelUp ? fireworkAnimation() : nil
    }
    
    private func handleMoveToTrash(index: IndexPath) {
     
        alert.showTrashAlert(controller: self, completion: {
            if  self.coins.checkIfAbleToBuy(cost: 500) {
                self.coins.spend(cost: 500)
                self.balance.text = self.fetchBalance()
                self.filterForDifficulty(index: index)
                self.deleteDesiredStack(indexPath: index, entityName: .Task, dataStack: self.tasks)
            } else {
                self.alert.notEnougCoinsAlert(controller: self)
            }
        })
    }
    
    func filterForDifficulty(index: IndexPath) {
        switch tasks[index.row].value(forKey: "difficulty") as? String {
        case "easy":
            availableTasks.taskWasRemoved(kind: .easy)
        case "normal":
            availableTasks.taskWasRemoved(kind: .normal)
        case "hard":
            availableTasks.taskWasRemoved(kind: .hard)
        default: print("Task does not exits, check saveCoreData()")
        }
        setupTaskLabels()
    }
    
    func findSkill(index: IndexPath?) {
        guard let index = index else { return }
        
        guard let skillIndex = tasks[index.row].value(forKey: "indexPath") as? Int,let xp = tasks[index.row].value(forKey: "reward") as? Float else { return }
      
        if tasks[index.row].value(forKey: "isSkillSelected") as? Bool ?? false {
            fetchDesiredStack(stack: .Skill)
            
                let skillPosition = skills[skillIndex]
                guard let skillName = skillPosition.value(forKey: "skillName") as? String, let skillXp = skillPosition.value(forKey: "skillCurrentXP") as? Float, let skillMaxXp = skillPosition.value(forKey: "skillMaxXP") as? Float, let skillLevel =  skillPosition.value(forKey: "skillLevel") as? Int else { return }
                let xpToProccess = xp + skillXp
                levelUpSkill.processXP(skillName: skillName ,maxXP: skillMaxXp, currentXP: xpToProccess, currentLevel: skillLevel,index: skillIndex)
                print(skillName, skillMaxXp, xpToProccess, skillLevel)
        }
    }
    
    func fetchSkillFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Skill")
        do {
            skills = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
// MARK: - Delegate
extension HomeScreenViewController: Updator, ShopDelegate {
    func update() {
        balance.text = fetchBalance()
        setupUiButton()
    }
    func updateData() {
        fetchDesiredStack(stack: .Task)
        setupTaskLabels()
        setupUiButton()
    }
    func fetchBalance()-> String {
        "\(coins.fetchCoins())"
    }
}
