//
//  StatisticsViewModel.swift
//  Simple
//
//  Created by Rastislav Smolen on 31/01/2023.
//

import Foundation
class StatisticsViewModel {
    weak var coordinator :  AppCoordinator!
    
    func calculateBarValue(mental: Double, physical: Double) -> (Double,Double) {
        var mentalValue = Double()
        var physicalValue = Double()
        let maxPercentage =  mental + physical
        
        mentalValue = mental / maxPercentage * 100
        physicalValue = physical / maxPercentage * 100
        
        mentalValue = mentalValue.rounded(toPlaces: 2)
        physicalValue = physicalValue.rounded(toPlaces: 2)
        
        return (mentalValue,physicalValue)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
