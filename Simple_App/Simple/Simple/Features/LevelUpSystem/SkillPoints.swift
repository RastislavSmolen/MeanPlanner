//
//  SkillPoints.swift
//  Simple
//
//  Created by Rastislav Smolen on 20/01/2023.
//

import Foundation
enum SkillPoint: String{
    case skillPoint = "skillPoint"
    func toString() -> String {
        self.rawValue
    }
}
class SkillPoints {
    var skillPoints = Int()
    let userDefaults = UserDefaults.standard
    
    func fetchSkillPoints()-> Int {
        return userDefaults.integer(forKey: SkillPoint.skillPoint.toString())
    }
    func saveSkillPoints(point: Int) {
        userDefaults.setValue(point, forKey: SkillPoint.skillPoint.toString())
    }
    func spendSkillPoint(){
        var count = fetchSkillPoints()
        if isSkillPointAvailable() {
            count -= 1
            saveSkillPoints(point: count)
        } else {
            print("not points availabe to spend")
        }
    }
    func addSkillPoint(skill: Int) {
       var count = fetchSkillPoints()
        count += 1
        saveSkillPoints(point: count)
    }
    func isSkillPointAvailable()-> Bool {
        return fetchSkillPoints() == 0  ? false : true
    }
}
