//
//  RingEffect.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import Foundation
import SwiftUI

class ColorsModel: ObservableObject {
    @Published var all: [Double] = [0.4, 0.6, 0.8, 1, 2]
    @Published var primaryColor: Color = .purple
    @Published var backgroundColor: Color = .black
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
        let defaultColors: [Color] = [Color(#colorLiteral(red: 0.003799867816, green: 0.01174801588, blue: 0.07808648795, alpha: 1)), Color(#colorLiteral(red: 0.147772789, green: 0.08009552211, blue: 0.3809506595, alpha: 1)), Color(#colorLiteral(red: 0.5622407794, green: 0.4161503613, blue: 0.9545945525, alpha: 1)), Color(#colorLiteral(red: 0.7909697294, green: 0.7202591896, blue: 0.9798423648, alpha: 1))]
        circles = defaultColors.map({ color in
            RingModel(position: generateRandomPosition(), color: color)
        })
    }
    
    func changeColor(gradients: [Double], color: Color) {
        for (index, circle) in circles.enumerated() {
            circle.color = Color(UIColor(color).colorWithBrightness(gradients[index]))
        }
    }
    
    func animate() {
        objectWillChange.send()
        
        for circle in circles {
            circle.position = generateRandomPosition()
        }
    }
    
    private func generateRandomPosition() -> CGPoint {
        CGPoint(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1))
    }
}
