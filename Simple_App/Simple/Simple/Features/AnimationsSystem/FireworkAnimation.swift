//
//  FireworkAnimation.swift
//  Simple
//
//  Created by Rastislav Smolen on 16/01/2023.
//

import Foundation
import UIKit

class Firework {
    func fireworkAnimation(view: UIView){
        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
       
        let size = CGSize(width: screenWidth, height: screenHeight)
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        view.addSubview(host)

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
