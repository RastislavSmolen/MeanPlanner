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
    
    //MARK: Animation variables and constants
    let levelUp = LevelUp()
    var displayLink: CADisplayLink?
    let animationDuration: Double = 0.3
    var animationStartDate = Date()
    var oldXp = Float()
    var elapsedTime = TimeInterval()
    private var startTime = 0.0
    
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

//MARK: - Animation
extension HomeScreenViewController {
    
    func xpCounterAnimation() {
        let now = Date()
        elapsedTime = now.timeIntervalSince(animationStartDate)
        
        stopDisplayLink()
        startTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(runAnimation))
        displayLink?.preferredFramesPerSecond = 0
        displayLink?.add(to: .main, forMode: .default)
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
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func fireworkAnimation(){
        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
       
        let size = CGSize(width: screenWidth, height: screenHeight)
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        self.view.addSubview(host)

        let particlesLayer = CAEmitterLayer()
        particlesLayer.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        host.layer.addSublayer(particlesLayer)
        host.layer.masksToBounds = true

        particlesLayer.emitterShape = .rectangle
        particlesLayer.emitterPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2 )
        particlesLayer.emitterSize = CGSize(width: screenWidth, height: screenHeight)
        particlesLayer.emitterMode = .outline
        particlesLayer.renderMode = .additive


        let cell1 = CAEmitterCell()

        cell1.name = "Parent"
        cell1.birthRate = 5.0
        cell1.lifetime = 2.5
        cell1.velocity = 0
        cell1.velocityRange = 0
        cell1.yAcceleration = 0
        cell1.emissionLongitude = -90.0 * (.pi / 180.0)
        cell1.emissionRange = 45.0 * (.pi / 180.0)
        cell1.scale = 0.0
        cell1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        cell1.redRange = 0.9
        cell1.greenRange = 0.9
        cell1.blueRange = 0.9

        let image1_2 = UIImage(named: "Spark")?.cgImage

        let subcell1_2 = CAEmitterCell()
        subcell1_2.contents = image1_2
        subcell1_2.name = "Firework"
        subcell1_2.birthRate = 20000.0
        subcell1_2.lifetime = 15.0
        subcell1_2.beginTime = 1.6
        subcell1_2.duration = 0.1
        subcell1_2.velocity = 190.0
        subcell1_2.yAcceleration = 80.0
        subcell1_2.emissionRange = 360.0 * (.pi / 180.0)
        subcell1_2.spin = 114.6 * (.pi / 180.0)
        subcell1_2.scale = 0.1
        subcell1_2.scaleSpeed = 0.09
        subcell1_2.alphaSpeed = -0.7
        subcell1_2.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        cell1.emitterCells = [subcell1_2]

        particlesLayer.emitterCells = [cell1]

        particlesLayer.emitterCells = [cell1]
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            host.removeFromSuperview()
        }
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
        guard let level = levelUp.level , let xp = levelUp.experience, let maxXp = levelUp.maximumExperience else { return }
        let rewardXp =  Float(tasks[index.row].value(forKey: "reward")as! Int)
        let newXp = rewardXp + xp
        oldXp = xp
        proccesXp(newXp: newXp)
        setupView(level: levelUp.fetchLevel(), xp: levelUp.fetchXP(), maxXp: levelUp.fetchMaxXp())
        levelUp.loadXp()
    }
    
    private func handleMarkAsDone(index: IndexPath) {
        saveXp(index: index)
        deleteFromCoreData(indexPath: index)
        guard let readyToPlaySound = levelUp.readyToPlaySound else { return }
        readyToPlaySound ? levelUp.playSound(soundName: "fanfare") : levelUp.playSound(soundName: "success")
        xpCounterAnimation()
        fireworkAnimation()
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
