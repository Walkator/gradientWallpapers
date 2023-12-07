//
//  ContentView.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

enum AnimationProperties {
    static let animationSpeed: Double = 4
    static let timerDuration: TimeInterval = 3
    static let blurRadius: CGFloat = 130
}

struct ContentView: View {
    @State private var timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
    @ObservedObject private var animator = RingEffect()
    @EnvironmentObject var model: ColorsModel
    @State private var viewIsHidden: Bool = false

    var body: some View {
        ZStack {
            CirclesView(circles: .constant(animator.circles))
                .simultaneousGesture(
                    TapGesture().onEnded {
                        if viewIsHidden {
                            viewIsHidden = false
                        }
                    }
                )
            
            VStack {
                TimeView()
                
                Spacer()
                
                ActionsUIView(hiddeView: {
                    viewIsHidden = true
                }).environmentObject(model)
            }.opacity(viewIsHidden ? 0 : 1)
        }
        .background(model.backgroundColor)
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onAppear {
            animateCircles()
            timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer) { _ in
            animator.changeColor(gradients: model.all, color: model.primaryColor, modeRandom: model.randomMovement)
            if model.randomMovement {
                animateCircles()
            }
        }.statusBar(hidden: viewIsHidden)
        .persistentSystemOverlays(.hidden)
    }
    
    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.animationSpeed)) {
            animator.animate()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ColorsModel())
    }
}
#endif
