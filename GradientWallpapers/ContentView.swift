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

struct ContentView: View {
    @State private var timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
    @ObservedObject private var animator = RingEffect()
    @EnvironmentObject var model: ColorsModel
    @State var screenshotMaker: ScreenshotMaker?

    var body: some View {
        ZStack {
            CirclesView(circles: .constant(animator.circles))
            
            VStack {
//                VStack {
//                    HStack {
//                        Image(systemName: "heart.fill")
//                            .foregroundColor(.white)
//                            .frame(width: 10, height: 10)
//                        Spacer()
//                    }.padding(.top, 25)
//                    .padding(.leading, 30)
//                    .edgesIgnoringSafeArea(.top)
//                }
                
                TimeView()
                
                Spacer()
                
                ButtonsView(actionScreenshot: {
                    if let screenshotMaker = screenshotMaker {
                        screenshotMaker.screenshot()
                    }
                }).environmentObject(model)
            }
        }
        .background(model.backgroundColor)
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onAppear {
            animateCircles()
            timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
        }//.onChange(of: model.primaryColor, perform: updateColors())
        .onReceive(timer) { _ in
            animator.changeColor(colors: model.all)
            animateCircles()
        }.screenshotView { screenshotMaker in
            self.screenshotMaker = screenshotMaker
        }
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
