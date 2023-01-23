//
//  CoreDataSystem.swift
//  Simple
//
//  Created by Rastislav Smolen on 23/01/2023.
//

import Foundation
import CoreData
import UIKit
protocol CoreDataFetcher {
    func fetchDesiredStack(stack: CoreDataEntity)
}
enum CoreDataEntity: String {
    case Task
    case Skill
    func toString() -> String {
        self.rawValue
    }
}
class CoreDataSystem {
    var tasks: [NSManagedObject] = []
    var skills: [NSManagedObject] = []
    var presistenContainer: NSPersistentContainer!
    
    
  private func findCorrectDataStack(stack: CoreDataEntity) -> [NSManagedObject]{
        switch stack {
        case .Task: return tasks
        case .Skill: return skills
        }
    }
    
    func fetchCoreData(entityName: CoreDataEntity) -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.toString())
        var stack = findCorrectDataStack(stack: entityName)
        do {
                stack = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return stack
    }
    
    func deleteFromCoreData(indexPath: IndexPath, entityName: CoreDataEntity, dataStack: [NSManagedObject]) -> [NSManagedObject] {
        var stack = dataStack
        let data = stack[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(data)
        stack.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
            stack.append(data)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        return fetchCoreData(entityName: entityName)
    }
    
    func updateCoreDataOfSkill(skillName: String, skillLevel: Int,skillXP: Float, skillMaxXP: Float,index: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Skill")
        
      
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let results = results else { return }
            results[index].setValue(skillName, forKeyPath: "skillName")
            results[index].setValue(skillLevel, forKeyPath: "skillLevel")
            results[index].setValue(skillXP, forKeyPath: "skillCurrentXP")
            results[index].setValue(skillMaxXP, forKeyPath: "skillMaxXP")
           
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try managedContext.save()
           }
        catch {
                print("Saving Core Data Failed: \(error)")
            }
        }
    
    func saveTaskToCoreData(name: String, detail: String,reward: Int,color: String,difficulty: String,skillName: String?,skillIndex: Int) {
      
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
