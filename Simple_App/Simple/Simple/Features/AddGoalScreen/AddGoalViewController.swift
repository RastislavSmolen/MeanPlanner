//
//  AddGoalViewController.swift
//  Simple
//
//  Created by Rastislav Smolen on 10/08/2022.
//

import Foundation
import UIKit
import CoreData

protocol Updator {
  func updateData()
}
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
    let pickerData = ["Art","Cleaning","Debt Management","Entertainment","Finance","Drink","Food","Household task","Health Management","Intelectual Improvement","Maternity","Reading","Relationship","Social","Skill","Time Management","Other"]
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    @IBOutlet  var buttons: [UIButton]!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var rewardSlider: UISlider!
    @IBOutlet weak var rewardSliderLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Storyboard Actions
    @IBAction func colorAction(_ sender: UIButton) {
        changeCollorOfPage(tag: sender.tag)
    }
    
    @IBAction func createTaskButton(_ sender: Any) {
        guard let taskName = taskNameTextField.text, let taskDetail = detailsTextField.text, let taskCategory = categoryTextField.text else { return }
        saveToCoreData(name: taskName, category: taskCategory, detail: taskDetail, reward: Int(rewardSlider.value), color: colorToSave)
        delegate?.updateData()
        self.dismiss(animated: true)
    }
    
    @IBAction func rewardSlider(_ sender: Any) {
        rewardSliderLabel.text = "\(Int((rewardSlider.value)))/100"
    }
    @IBAction func categoryTexfieldDidBegin(_ sender: Any) {
        let text = categoryTextField.text == "" ? pickerData[0] : pickerData[pickerRow]
        categoryTextField.text = text
        
    }
    //MARK: - Main logic
    private func changeCollorOfPage(tag: Int) {
        switch tag {
        case 0 : color(UIColor(hex: ColorPaint.yellow.description), hex: ColorPaint.yellow.description)
        case 1 : color(UIColor(hex: ColorPaint.teal.description), hex: ColorPaint.teal.description)
        case 2 : color(UIColor(hex: ColorPaint.red.description), hex: ColorPaint.red.description)
        case 3 : color(UIColor(hex: ColorPaint.purple.description), hex: ColorPaint.purple.description)
        case 4 : color(UIColor(hex: ColorPaint.pink.description), hex: ColorPaint.pink.description)
        case 5 : color(UIColor(hex: ColorPaint.green.description), hex: ColorPaint.green.description)
        case 6 : color(UIColor(hex: ColorPaint.cyan.description), hex: ColorPaint.cyan.description)
            default: print("Cant change color no tag attached to sender")
        }
    }
    
    private func color(_ color: UIColor!, hex: String) {
        colorView.backgroundColor = color
        rewardSlider.tintColor =  color
        createButton.tintColor =  color
        toolBar.tintColor = color
        colorToSave = hex
    }
}

// MARK: - Setup Extension
extension AddGoalViewController  {
    
    func setup() {
        configureTextField()
        configurePickerView()
        configureRewardSlider()
        colorView.backgroundColor = UIColor(hex: ColorPaint.cyan.description)
    }
    
}

// MARK: - Texfield Setup
extension AddGoalViewController : UITextFieldDelegate {
    
    
    private func configureTextField() {
        taskNameTextField.delegate = self
        categoryTextField.delegate = self
        detailsTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - Picker Setup
extension AddGoalViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func configurePickerView() {
        
        picker.delegate = self
        picker.dataSource = self

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(hex: ColorPaint.cyan.description)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.inputView = picker

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
        categoryTextField.text = pickerData[row]
    }
    
    @objc func donePicker() {
        categoryTextField.resignFirstResponder()
    }
    
}

//MARK: - Slider Setup
extension AddGoalViewController {
    private func configureRewardSlider() {
        rewardSlider.minimumValue = 0
        rewardSlider.maximumValue = 1000
        rewardSlider.value = 0
        rewardSlider.tintColor = UIColor(hex: ColorPaint.cyan.description)
        rewardSliderLabel.text = "\(Int((rewardSlider.value)))/100"
    }
}

//MARK: - CoreData
extension AddGoalViewController {
    
    func saveToCoreData(name: String,category: String, detail: String,reward: Int,color: String) {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Task",in: managedContext)!
      let task = NSManagedObject(entity: entity, insertInto: managedContext)
      
        task.setValue(name, forKeyPath: "taskName")
        task.setValue(false, forKeyPath: "isFinnished")
        task.setValue(category, forKeyPath: "categoryName")
        task.setValue(reward, forKeyPath: "reward")
        task.setValue(detail, forKeyPath: "taskDetails")
        task.setValue(color, forKey: "taskColor")

      do {
        try managedContext.save()
        tasks.append(task)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
}
