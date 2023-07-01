//
//  RingEffect.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import Foundation
import SwiftUI

class ColorsModel: ObservableObject {
    @Published var all: [Double] = [0.4, 0.6, 0.8, 1, 2.5]
    @Published var primaryColor: Color = .purple
    @Published var backgroundColor: Color = .black
    @Published var randomMovement: Bool = true
}

final class RingModel: Identifiable {
    let id = UUID().uuidString
    var color: Color
    var position: CGPoint
    
    internal init(position: CGPoint, color: Color) {
        self.position = position
        self.color = color
    }
}

final class RingEffect: ObservableObject {
    @Published private(set) var circles: [RingModel] = []
    
    init() {
        let primaryColor: UIColor = UIColor(Color.purple)
        let defaultColors: [Color] =
            [Color(primaryColor.colorWithBrightness(0.4)),
             Color(primaryColor.colorWithBrightness(0.6)),
             Color(primaryColor.colorWithBrightness(0.8)),
             Color(primaryColor.colorWithBrightness(1)),
             Color(primaryColor.colorWithBrightness(2.5))]
        
        circles = defaultColors.map({ color in
            RingModel(position: generateRandomPosition(), color: color)
        })
    }
    
    func changeColor(gradients: [Double], color: Color, modeRandom: Bool) {
        var newCircles: [RingModel] = []
        
        for (index, gradient) in gradients.enumerated() {
            newCircles.append(RingModel(position: modeRandom ? circles.getElement(index)?.position ?? generateRandomPosition() : calculateStaticPosition(index: index), color: Color(UIColor(color).colorWithBrightness(gradient))))
        }
       
        circles = newCircles
    }
    
    func animate() {
        objectWillChange.send()
        
        circles.forEach({ $0.position = generateRandomPosition() })
    }
    
    private func generateRandomPosition() -> CGPoint {
        CGPoint(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1))
    }
    
    private func calculateStaticPosition(index: Int) -> CGPoint {
        CGPoint(x: 0.5, y: 1 - (Double(index) * 0.1))
    }
}
