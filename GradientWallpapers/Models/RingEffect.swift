//
//  RingEffect.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import Foundation
import SwiftUI

class ColorsModel: ObservableObject {
    @Published var all: [Color] = [Color(#colorLiteral(red: 0.003799867816, green: 0.01174801588, blue: 0.07808648795, alpha: 1)), Color(#colorLiteral(red: 0.147772789, green: 0.08009552211, blue: 0.3809506595, alpha: 1)), Color(#colorLiteral(red: 0.5622407794, green: 0.4161503613, blue: 0.9545945525, alpha: 1)), Color(#colorLiteral(red: 0.7909697294, green: 0.7202591896, blue: 0.9798423648, alpha: 1))]
    @Published var primaryColor: Color = .purple
    @Published var backgroundColor: Color = .black
}

final class RingModel: Identifiable {
    let id = UUID().uuidString
    let color: Color
    var position: CGPoint
    
    internal init(position: CGPoint, color: Color) {
        self.position = position
        self.color = color
    }
}

final class RingEffect: ObservableObject {
    @Published private(set) var circles: [RingModel] = []
    @Published var model: ColorsModel?
    
    init() {
        let defaultColors: [Color] = [Color(#colorLiteral(red: 0.003799867816, green: 0.01174801588, blue: 0.07808648795, alpha: 1)), Color(#colorLiteral(red: 0.147772789, green: 0.08009552211, blue: 0.3809506595, alpha: 1)), Color(#colorLiteral(red: 0.5622407794, green: 0.4161503613, blue: 0.9545945525, alpha: 1)), Color(#colorLiteral(red: 0.7909697294, green: 0.7202591896, blue: 0.9798423648, alpha: 1))]
        circles = defaultColors.map({ color in
            RingModel(position: generateRandomPosition(), color: color)
        })
    }
    
    func changeColor(colors: [Color]) {
        circles.removeAll()
        circles = colors.map({ color in
            RingModel(position: generateRandomPosition(), color: color)
        })
//        guard let colors = color else {
//            circles.append(RingModel(position: RingEffect.generateRandomPosition(), color: .cyan))
//            return
//        }
        //circles
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
