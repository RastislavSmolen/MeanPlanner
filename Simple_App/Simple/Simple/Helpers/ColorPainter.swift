//
//  ColorPainter.swift
//  Simple
//
//  Created by Rastislav Smolen on 26/08/2022.
//

import Foundation

enum ColorPaint: CustomStringConvertible {
    case yellow
    case teal
    case red
    case purple
    case pink
    case green
    case cyan
    
    var description : String {
        switch self {
        case .yellow: return "#FFCC00"
        case .teal: return "#30B0C7"
        case .red: return "#FF3B30"
        case .purple: return "#AF52DE"
        case .pink: return "#FF2D55"
        case .green: return "#34C759"
        case .cyan: return "#32ADE6"
        }
    }
}
