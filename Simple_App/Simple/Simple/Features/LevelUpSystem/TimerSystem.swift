//
//  TimerSystem.swift
//  Simple
//
//  Created by Rastislav Smolen on 25/01/2023.
//

import Foundation
enum Timers: String {
    case startTimerForEasy
    case startTimerForNormal
    case startTimerForHard
    func toString()-> String {
        self.rawValue
    }
}
enum Running: String {
    case isRunningForEasy
    case isRunningForNormal
    case isRunningForHard
    func toString()-> String {
        self.rawValue
    }
}
class TimerSystem {
    var startDate: Date?
    var endDate: Date?
    var running: Bool?
    var timer: Timer?
    
    let userDefaults = UserDefaults.standard
    
//    @IBAction func addTaskAction(_ sender: Any) {
//        setStartDate(starDate: Date())
//        isRunning  ?? false ? nil : startTimer()
//        addGoalAction()
//    }
   func startTimer(difficulty: Difficulty,timer: Timers,isRunning: Running) {
       if running ?? false {
           print("timer is already Running")
       } else {
           userDefaults.setValue(Date(), forKey: timer.toString())
           userDefaults.set(true, forKey: isRunning.toString())
           fetchStartTimer(difficulty: difficulty, timer: timer, isRunning: isRunning)
           startTimer()
       }
           
    }
    func fetchStartTimer(difficulty: Difficulty,timer: Timers,isRunning: Running) {
            startDate = userDefaults.value(forKey: timer.toString()) as? Date
            running = userDefaults.value(forKey: isRunning.toString()) as? Bool
    }
    func checkIfTheTimerIsRunning() {
        if running ?? false {
            let diff = Date().timeIntervalSince(startDate ?? Date())
            print(diff)
            setTimeLabel(Int(diff))
        } else {
            timer?.invalidate()
            print("no timer running")
        }
        
    }
    
    func setTimeLabel(_ val: Int)
    {
        let time = secondsToHoursMinutesSeconds(val)
        print(time)
        if time.2 >= 15 {
            print("TimerIsDone")
            userDefaults.set(false, forKey: "isRunning")
            running = userDefaults.bool(forKey: "isRunning")
            timer?.invalidate()
        } else {
            
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
}
