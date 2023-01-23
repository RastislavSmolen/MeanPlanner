//
//  AddGoalViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 10/08/2022.
//

import Foundation
import UIKit
import CoreData

class AddGoalViewController : UIViewController {
    
    // MARK: - Variables
    var delegate : Updator?
    var viewModel : AddGoalViewModel!
    var pickerRow : Int!
    var tasks : [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    var colorToSave: String!

    // MARK: - Constants
    let picker = UIPickerView()
    let toolBar = UIToolbar()
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var xpLabel: UILabel!
    
    @IBOutlet weak var skillNameLabel: UILabel!
    
    let availableTasks = AvailableTask()
    var startValue: Double {
        return Double.random(in: 0...200)
    }
    let endValue: Double = 1000
    var displayLink: CADisplayLink?
    let animationDuration: Double = 1.5
    var animationStartDate = Date()
    var generatedXp = Int()
    var elapsedTime = TimeInterval()
    var difficultyToSave = String()
    var skillName = String()
    var skillIndex = Int()
    private var startTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        checkTaskAvailibility()
        let skill = skillName == "" ? "" : skillName
        skillNameLabel.text = skill
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let skill = skillName == "" ? "" : skillName
        skillNameLabel.text = skill
    }
    // MARK: - Storyboard Actions
    @IBAction func chooseSkillAction(_ sender: Any) {
     
            viewModel.navigateToSkillTree(delegate: self)
  
    }
    @IBAction func easyTaskButtonAction(_ sender: Any) {
        handleButtonBehaviour(difficulty: .easy)
    }
 
    @IBAction func normalTaskButtonAction(_ sender: Any) {
        handleButtonBehaviour(difficulty: .normal)
    }
    @IBAction func hardActionButton(_ sender: Any) {
        handleButtonBehaviour(difficulty: .hard)
    }
    
    @IBAction func createTaskButton(_ sender: Any) {
        guard let taskName = taskNameTextField.text, let taskDetail = detailsTextField.text else { return }
        saveTaskToCoreData(name: taskName, detail: taskDetail, reward: generatedXp, color: colorToSave ?? "#32ADE6", difficulty: difficultyToSave, skillName: skillName)
        delegate?.updateData()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Main logic
    func checkTaskAvailibility() {
        availableTasks.checkTaskAvailability(difficulty: .easy) ? isButtonEnabled(true, button: easyButton) : isButtonEnabled(false, button: easyButton)
        availableTasks.checkTaskAvailability(difficulty: .normal) ? isButtonEnabled(true, button: normalButton) : isButtonEnabled(false, button: normalButton)
        availableTasks.checkTaskAvailability(difficulty: .hard) ? isButtonEnabled(true, button: hardButton) : isButtonEnabled(false, button: hardButton)
    }
    
    func handleButtonBehaviour(difficulty: Difficulty) {
        switch difficulty {
        case .easy:
            generatedXp = Int.random(in: 5...55)
            availableTasks.isAbleToAddAnotherTask(.easy, amountLeft: availableTasks.fetchAvailableTasks(difficulty: .easy)) ? isButtonEnabled(true, button: easyButton) : isButtonEnabled(false, button: easyButton)
            isButtonEnabled(false, button: hardButton)
            isButtonEnabled(false, button: normalButton)
            difficultyToSave = "easy"
            color(UIColor(hex: ColorPaint.green.description), hex: ColorPaint.green.description)
        case .normal:
            generatedXp = Int.random(in: 55...105)
            availableTasks.isAbleToAddAnotherTask(.normal, amountLeft: availableTasks.fetchAvailableTasks(difficulty: .normal)) ? isButtonEnabled(true, button: normalButton) : isButtonEnabled(false, button: normalButton)
            isButtonEnabled(false, button: easyButton)
            isButtonEnabled(false, button: hardButton)
            difficultyToSave = "normal"
            color(UIColor(hex: ColorPaint.purple.description), hex: ColorPaint.purple.description)
        case .hard:
            generatedXp = Int.random(in: 105...155)
            availableTasks.isAbleToAddAnotherTask(.hard, amountLeft: availableTasks.fetchAvailableTasks(difficulty: .hard)) ? isButtonEnabled(true, button: hardButton) : isButtonEnabled(false, button: hardButton)
            isButtonEnabled(false, button: easyButton)
            isButtonEnabled(false, button: normalButton)
            difficultyToSave = "hard"
            color(UIColor(hex: ColorPaint.red.description), hex: ColorPaint.red.description)
        }
        xpCounterAnimation()

    }
    
    func isButtonEnabled(_ bool: Bool, button: UIButton) {
        button.isEnabled = bool
    }    
    private func color(_ color: UIColor!, hex: String) {
        colorView.backgroundColor = color
        createButton.tintColor =  color
        toolBar.tintColor = color
        colorToSave = hex
    }
}
//MARK: - Animation Extention
extension AddGoalViewController {
    
    @objc func runAnimation() {
        let elapsedTime = CACurrentMediaTime() - startTime
        if elapsedTime > animationDuration {
            self.xpLabel.text = "\(generatedXp) xp"
            stopDisplayLink()
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (Double(generatedXp) - startValue)
            self.xpLabel.text = "\(Int(value)) xp"
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
// MARK: - Setup Extension
extension AddGoalViewController  {
    
    func setup() {
        configureTextField()
        colorView.backgroundColor = UIColor(hex: ColorPaint.cyan.description)
    }
    
}
extension AddGoalViewController: CoreDataPasser {
    func passData(data: NSManagedObject,indexPath: IndexPath) {
        guard let skill = data.value(forKey: "skillName") as? String else { return }
        skillName = skill
        skillNameLabel.text = skillName
        skillIndex = indexPath.row
    }
    
}

// MARK: - Texfield Setup
extension AddGoalViewController : UITextFieldDelegate {
    
    
    private func configureTextField() {
        taskNameTextField.delegate = self
        detailsTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: - CoreData
extension AddGoalViewController {
    
    func saveTaskToCoreData(name: String, detail: String,reward: Int,color: String,difficulty: String,skillName: String?) {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let skillName = skillName else { return }
    
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Task",in: managedContext)!
      let task = NSManagedObject(entity: entity, insertInto: managedContext)
      
        task.setValue(name, forKeyPath: "taskName")
        task.setValue(false, forKeyPath: "isFinnished")
        task.setValue(reward, forKeyPath: "reward")
        task.setValue(detail, forKeyPath: "taskDetails")
        task.setValue(color, forKey: "taskColor")
        task.setValue(difficulty, forKey: "difficulty")
        task.setValue(skillName, forKey: "skillName")
        task.setValue(skillIndex, forKey: "indexPath")

      do {
        try managedContext.save()
        tasks.append(task)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
}
