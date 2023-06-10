//
//  TimeView.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

struct TimeView: View {
    var body: some View {
        VStack {
            Text(getDate())
                .font(.system(size: 24.0, weight: .semibold, design: .rounded))
                .foregroundColor(.white).blendMode(.overlay)
                .blendMode(.difference)
                .blendMode(.hue)
                .padding(.top, 20)
            
            Text(getTime())
                .font(.system(size: 88.0,weight: .medium, design: .rounded))
                .foregroundColor(.white).blendMode(.overlay)
                .blendMode(.difference)
                .blendMode(.hue)
        }
    }
    
    private func getTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
    
    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d, MMM"
        return formatter.string(from: Date())
    }
}

#if DEBUG
struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView()
    }
}
#endif
