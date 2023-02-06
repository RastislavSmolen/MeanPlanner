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
    @IBOutlet weak var chooseSkillButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var segmenter: UISegmentedControl!
    
    @IBOutlet weak var balanceLabel: UILabel!
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
    let coreData = CoreDataSystem()
    let timerSystem = TimerSystem()
    let alert = Alert()
    var balancerValue : Int = 0
    var didTapButton = false
    let coins = Coins()
    
    var isSkillSelected: Bool = false
    
    let userDefaults = UserDefaults.standard
    
    private var startTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let skill = skillName == "" ? "" : skillName
        skillNameLabel.text = skill
        balanceLabel.text = self.fetchBalance()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(hex: "ffffff")
        let skill = skillName == "" ? "" : skillName
        skillNameLabel.text = skill
    }
    // MARK: - Storyboard Actions
    @IBAction func chooseSkillAction(_ sender: Any) {
        
        viewModel.navigateToSkillTree(delegate: self)
        
    }
    @IBAction func easyTaskButtonAction(_ sender: Any) {
        if didTapButton {
            alert.generatingXpAlert(controller: self) {
               
                if self.coins.checkIfAbleToBuy(cost: 500){
                    self.coins.spend(cost: 500)
                    self.handleButtonBehaviour(difficulty: .easy)
                    self.balanceLabel.text = self.fetchBalance()
                } else {
                    self.alert.notEnougCoinsAlert(controller: self)
                }
            }
        } else {
            handleButtonBehaviour(difficulty: .easy)
            didTapButton = true
        }
    }
    func fetchBalance()-> String {
        "\(coins.fetchCoins())"
    }
    @IBAction func normalTaskButtonAction(_ sender: Any) {
        if didTapButton {
            alert.generatingXpAlert(controller: self) {
               
                if self.coins.checkIfAbleToBuy(cost: 650){
                    self.coins.spend(cost: 650)
                    self.handleButtonBehaviour(difficulty: .normal)
                    self.balanceLabel.text = self.fetchBalance()
                } else {
                    self.alert.notEnougCoinsAlert(controller: self)
                }
            }
        } else {
            handleButtonBehaviour(difficulty: .easy)
            didTapButton = true
        }
    }
    @IBAction func hardActionButton(_ sender: Any) {
        if didTapButton {
            alert.generatingXpAlert(controller: self) {
               
                if self.coins.checkIfAbleToBuy(cost: 750){
                    self.coins.spend(cost: 750)
                    self.handleButtonBehaviour(difficulty: .easy)
                    self.balanceLabel.text = self.fetchBalance()
                } else {
                    self.alert.notEnougCoinsAlert(controller: self)
                }
            }
        } else {
            handleButtonBehaviour(difficulty: .easy)
            didTapButton = true
        }
    }
    
    @IBAction func segmenterAction(_ sender: Any) {
        switch segmenter.selectedSegmentIndex {
        case 0: print("Mental")
            balancerValue = 0
        case 1: print("Physical")
            balancerValue = 1
        case 2: print("Neither")
            balancerValue = 2
        default: break
        }
    }
    @IBAction func createTaskButton(_ sender: Any) {
        guard let taskName = taskNameTextField.text, let taskDetail = detailsTextField.text else { return }
        if skillName.isEmpty {
            coreData.saveTaskToCoreData(name: taskName, detail: taskDetail, reward: generatedXp, color: colorToSave ?? "#32ADE6", difficulty: difficultyToSave, skillName: skillName,skillIndex: skillIndex, isSkillSelected: false, balancerValue: balancerValue)
        } else {
            coreData.saveTaskToCoreData(name: taskName, detail: taskDetail, reward: generatedXp, color: colorToSave ?? "#32ADE6", difficulty: difficultyToSave, skillName: skillName,skillIndex: skillIndex, isSkillSelected: true, balancerValue: balancerValue)
        }
        
        delegate?.updateData()
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: - Difficulty
extension AddGoalViewController {
    
    func handleButtonBehaviour(difficulty: Difficulty) {
        switch difficulty {
        case .easy:
            generatedXp = Int.random(in: 5...55)
            availableTasks.taskWasAdded(kind: .easy)
            isButtonEnabled(false, button: hardButton)
            isButtonEnabled(false, button: normalButton)
            difficultyToSave = "easy"
            color(UIColor(hex: ColorPaint.green.description), hex: ColorPaint.green.description)
            xpCounterAnimation()

        case .normal:
            generatedXp = Int.random(in: 55...105)
            availableTasks.taskWasAdded(kind: .normal)
            isButtonEnabled(false, button: easyButton)
            isButtonEnabled(false, button: hardButton)
            difficultyToSave = "normal"
            color(UIColor(hex: ColorPaint.purple.description), hex: ColorPaint.purple.description)
            xpCounterAnimation()

        case .hard:
            generatedXp = Int.random(in: 105...155)
            availableTasks.taskWasAdded(kind: .hard)
            isButtonEnabled(false, button: easyButton)
            isButtonEnabled(false, button: normalButton)
            difficultyToSave = "hard"
            color(UIColor(hex: ColorPaint.red.description), hex: ColorPaint.red.description)
            xpCounterAnimation()

        }
        
    }
    func hideAndShowAlert(_ bool: Bool, button: UIButton,difficulty: Difficulty) {
        button.isEnabled = bool
        alert.showMaxCapacityReachedAlert(forTask: difficulty.toString(), controller: self)
    }
    func isButtonEnabled(_ bool: Bool, button: UIButton) {
        button.isEnabled = bool
    }
    private func color(_ color: UIColor!, hex: String) {
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
        setButtonStyle()
        setupSegmenter()
    }
    func setButtonStyle() {
        easyButton.layer.borderWidth = 1
        easyButton.layer.borderColor = UIColor(hex: ColorPaint.green.description).cgColor
        easyButton.layer.cornerRadius = 10
        
        normalButton.layer.borderWidth = 1
        normalButton.layer.borderColor = UIColor(hex: ColorPaint.purple.description).cgColor
        normalButton.layer.cornerRadius = 10
        
        hardButton.layer.borderWidth = 1
        hardButton.layer.borderColor = UIColor(hex: ColorPaint.red.description).cgColor
        hardButton.layer.cornerRadius = 10
        
        chooseSkillButton.layer.cornerRadius = 10
        
        createButton.backgroundColor = UIColor(hex: "ae29d3")
        createButton.tintColor = UIColor(hex: "ae29d3")
        createButton.layer.cornerRadius = 10
    }
    func setupSegmenter(){
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTextAtributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "808080",alpha: 0.5)]
        segmenter.setTitleTextAttributes(unselectedTextAtributes, for: .normal)
        segmenter.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    
}
//MARK: CORE DATA
extension AddGoalViewController: CoreDataPasser {
    func passData(data: NSManagedObject,indexPath: IndexPath) {
        guard let skill = data.value(forKey: "skillName") as? String,
              let skillLevel = data.value(forKey: "skillLevel") as? Int else
        { return }
        skillName = skill
        skillNameLabel.text = "\(skillLevel).lvl \(skillName)"
        skillIndex = indexPath.row
    }
    
}
// MARK: - Texfield Setup
extension AddGoalViewController : UITextFieldDelegate {
    
    
    private func configureTextField() {
        setStyleOfTextfields(textField: taskNameTextField)
        setStyleOfTextfields(textField: detailsTextField)
        
    }
    func setStyleOfTextfields(textField: UITextField){
        textField.delegate = self
        textField.backgroundColor = UIColor(hex: "121212")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(hex: "ae29d3").cgColor
        textField.textColor = .white
        taskNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Play Tennis",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        detailsTextField.attributedPlaceholder = NSAttributedString(
            string: "Desctribe task max 150 characters",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
