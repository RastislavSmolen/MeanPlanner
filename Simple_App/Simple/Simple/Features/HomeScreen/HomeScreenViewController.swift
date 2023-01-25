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
    let todaysDate = NSDate()
    
    var isEmpty :  Bool {
        return tasks.count == 0 ? true : false
    }
    var tasks: [NSManagedObject] = []
    var skills: [NSManagedObject] = []
#warning("user default only for testing purposes")
#warning("move all user defaults to same place for better management")
    let userDefaults = UserDefaults.standard
    
    var startDate: Date?
    var endDate: Date?
    var isRunning: Bool?
    var timer: Timer?
    
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
        resetEverything()
        addObserver()
        setupXp()
        fetchDesiredStack(stack: .Task)
        setupUI()
        isRunning = userDefaults.bool(forKey: "isRunning")
        startDate = userDefaults.object(forKey: "startDate") as? Date
        startTimer()
    }
   
    func addObserver(){
        NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self]  notification in
            guard let balance = self?.coins.fetchCoins(),let skill = self?.skillPoints.fetchSkillPoints() else { return }
            self?.balance.text = "Balance: \(balance)"
            self?.skillPointButton.setTitle("Skill Points: \(skill)", for: .normal)
        }
    }
//MARK: - IBActions
    @IBAction func didTapClosingSection(_ sender: Any) {
        if !detailTaskView.isHidden {
            configureDetailView(isHidden: true)
        }
    }
    func blockAddTaskButton() {
        if let waitingDate:NSDate = UserDefaults.standard.value(forKey: "waitingDate") as? NSDate {
                if (todaysDate.compare(waitingDate as Date) == ComparisonResult.orderedDescending) {
                    addTaskButton.isEnabled = true
                }
                else {
                    addTaskButton.isEnabled = false
                }
            }
    }

    @IBAction func addTaskAction(_ sender: Any) {
        setStartDate(starDate: Date())
        isRunning  ?? false ? nil : startTimer()
        addGoalAction()
    }
    func setStartDate(starDate: Date?) {
        startDate = starDate
        userDefaults.setValue(Date(), forKey: "startDate")
        userDefaults.setValue(true, forKey: "isRunning")
    }
    func checkIfTheTimerIsRunning(){
        if isRunning ?? false {
            let diff = Date().timeIntervalSince(startDate ?? Date())
            print(diff)
            setTimeLabel(Int(diff))
        } else {
            timer?.invalidate()
            print("no timer running")
        }
        
    }
    func calculateEndDate(){
        
    }
        func setTimeLabel(_ val: Int)
        {
            let time = secondsToHoursMinutesSeconds(val)
            print(time)
            if time.1 >= 1 {
                print("TimerIsDone")
                userDefaults.set(false, forKey: "isRunning")
                addTaskButton.isEnabled = true
                timer?.invalidate()
            } else {
                addTaskButton.isEnabled = false
            }
          // let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
          //  timeLabel.text = timeString
        }
    @objc func fireTimer(){
        checkIfTheTimerIsRunning()
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
        func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
        {
            let hour = ms / 3600
            let min = (ms % 3600) / 60
            let sec = (ms % 3600) % 60
            return (hour, min, sec)
        }
        
//        func makeTimeString(hour: Int, min: Int, sec: Int) -> String
//        {
//            var timeString = ""
//            timeString += String(format: "%02d", hour)
//            timeString += ":"
//            timeString += String(format: "%02d", min)
//            timeString += ":"
//            timeString += String(format: "%02d", sec)
//            return timeString
//        }
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
        skillPointButton.setTitle("Skill Points: \(skillPoints.fetchSkillPoints())", for: .normal)
        balance.text = "Balance: \(coins.fetchCoins())"

        setupTaskLabels()
        proggressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        
        configureDetailView(isHidden: true)
        
        userImageView.layer.cornerRadius = 100
        currentTasksTableView.dataSource = self
        currentTasksTableView.delegate = self
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
// MARK: - RESETER
extension HomeScreenViewController {
    func resetEverything(){
        userDefaults.setValue(10, forKey: "experience")
        userDefaults.setValue(1, forKey: "currentLevel")
        userDefaults.setValue(100, forKey: "maxXp")
//
//        availableTasks.saveTasks(difficulty: .easy, amountLeft: 0)
//        availableTasks.saveTasks(difficulty: .normal, amountLeft: 0)
//        availableTasks.saveTasks(difficulty: .hard, amountLeft: 0)
//
//        availableTasks.setMaxAmountForTasks(difficulty: .easy ,maxAmount: 3)
//        availableTasks.setMaxAmountForTasks(difficulty: .normal ,maxAmount: 2)
//        availableTasks.setMaxAmountForTasks(difficulty: .hard ,maxAmount: 1)
        skillPoints.saveSkillPoints(point: 10)
        coins.saveCoins(coins: 0 )
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
        
        guard let experience = levelUp.fetchUserData(kind: .float, forkey: .experience) as? Float,
              let maxXp = levelUp.fetchUserData(kind: .float, forkey: .maxXp) as? Float,
              let level = levelUp.fetchUserData(kind: .integer, forkey: .currentLevel) as? Int
        else { return }
        
        setupView(level: level, xp: experience, maxXp: maxXp)
        levelUp.loadXp()
    }
    
    private func handleMarkAsDone(index: IndexPath) {
        saveXp(index: index)
        filterForDifficulty(index: index)
        #warning("Bug here, it will always pick 1 cell if not specified otherwise")
        findSkill(index: index)
        deleteDesiredStack(indexPath: index, entityName: .Task, dataStack: tasks)
        guard let readyToLevelUp = levelUp.readyToLevelUp else { return }
//        readyToLevelUp ? levelUp.playSound(soundName: "fanfare"): levelUp.playSound(soundName: "success")
//        readyToLevelUp ? fireworkAnimation() : nil
        xpCounterAnimation()
        configureDetailView(isHidden: true)
        balance.text = "Balance: \(coins.fetchCoins())"
        skillPointButton.setTitle("Skill points: \(skillPoints.fetchSkillPoints())", for: .normal)
    }
    
    private func handleMoveToTrash(index: IndexPath) {
        filterForDifficulty(index: index)
        deleteDesiredStack(indexPath: index, entityName: .Task, dataStack: tasks)
    }
    
    func filterForDifficulty(index: IndexPath) {
        switch tasks[index.row].value(forKey: "difficulty") as? String {
        case "easy":
            availableTasks.taskWasRemoved(kind: .easy)
            print("")
        case "normal":
            print("")
            availableTasks.taskWasRemoved(kind: .normal)
        case "hard":
            print("")
            availableTasks.taskWasRemoved(kind: .hard)
        default: print("Task does not exits, check saveCoreData()")
        }
        setupTaskLabels()
    }
    
    func findSkill(index: IndexPath?) {
        guard let index = index else { return }
        
        guard let skillIndex = tasks[index.row].value(forKey: "indexPath") as? Int,let xp = tasks[index.row].value(forKey: "reward") as? Float else { return }
        fetchDesiredStack(stack: .Skill)
        
        let skillPosition = skills[skillIndex]
        guard let skillName = skillPosition.value(forKey: "skillName") as? String, let skillXp = skillPosition.value(forKey: "skillCurrentXP") as? Float, let skillMaxXp = skillPosition.value(forKey: "skillMaxXP") as? Float, let skillLevel =  skillPosition.value(forKey: "skillLevel") as? Int else { return }
        let xpToProccess = xp + skillXp
        levelUpSkill.processXP(skillName: skillName ,maxXP: skillMaxXp, currentXP: xpToProccess, currentLevel: skillLevel,index: skillIndex)
        print(skillName, skillMaxXp, xpToProccess, skillLevel)
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
extension HomeScreenViewController: Updator {
    func updateData() {
        fetchDesiredStack(stack: .Task)
        setupTaskLabels()
        skillPointButton.setTitle("Skill points: \(skillPoints.fetchSkillPoints())", for: .normal)
    }

    func testNotification(){
          let center = UNUserNotificationCenter.current()
          let content = UNMutableNotificationContent()
          content.title = "Great new you can add new tasks"
          content.body = "Timer runned out"
          content.sound = .default
          content.userInfo = ["value": "Data with local notification"]
          let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(60))
          let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
          let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
          center.add(request) { (error) in
              if error != nil {
                  print("Error = \(error?.localizedDescription ?? "error local notification")")
              }
          }
    }
}
