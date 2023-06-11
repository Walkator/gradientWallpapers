//
//  CirclesView.swift
//  GradientWallpapers
//
//  Created by Walkator on 11/6/23.
//

import SwiftUI

struct CirclesView: View {
    @Binding var circles: [RingModel]

    var body: some View {
        ZStack {
            ForEach(circles) { circle in
                Ring(originOffset: circle.position)
                .foregroundColor(circle.color)
            }
        }.blur(radius: AnimationProperties.blurRadius)
    }
}

#if DEBUG
struct CirclesView_Previews: PreviewProvider {
    static var previews: some View {
        CirclesView(circles: .constant([RingModel(position: CGPoint(x: 0, y: 0), color: .cyan)]))
    }
}
#endif
