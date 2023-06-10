//
//  Array+Additions.swift
//  GradientWallpapers
//
//  Created by Walkator on 10/6/23.
//

import Foundation

extension Array {
    
    func getElement(_ index: Int) -> Element? {
        guard index >= 0, index < self.count else {
            return nil
        }
        
        return self[index]
    }
}
