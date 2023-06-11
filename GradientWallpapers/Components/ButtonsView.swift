//
//  ButtonsView.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var model: ColorsModel
    @State private var slider: [Double] = [0.2, 0.3, 0.4, 0.5, 0.6, 0, 0]
    @State private var numOfSliders: Int = 4

    var body: some View {
        VStack {
            Text("Edit gradient by rings")
                .bold()
                .padding(.top, 28)
            
            Spacer()
            
            ForEach((0...numOfSliders - 1).reversed(), id: \.self) { index in
                HStack {
                    Rectangle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color(UIColor(model.primaryColor).colorWithBrightness(slider[index])))
                        .padding(.leading, 24)
                        .padding(.trailing)
                    
                    HStack {
                        Slider(value: $slider[index], in: 0.1...2.5, onEditingChanged: { data in
                            changeColor(index, brightness: slider[index])
                        })
                        .padding([.trailing], index < 4 ? 24 : 0)
                        
                        if index >= 4 {
                            Button(action: {
                                removeGradient(index: index)
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                            })
                            .padding([.trailing], 24)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                addNewGradient()
            }, label: {
                Text("Add more rings")
            }).opacity(numOfSliders == 7 ? 0 : 100)
        }
        .onAppear() {
            setLoadGradientSliders()
        }
    }
    
    private func changeColor(_ index: Int, brightness: Double) {
        if model.all.getElement(index) == nil {
            model.all.append(0.6)
        }
        
        model.all[index] = slider[index]
    }
    
    private func setLoadGradientSliders() {
        slider = model.all
        numOfSliders = model.all.count
    }
    
    private func addNewGradient() {
        let sliderNewValue: Int = numOfSliders + 1
        if sliderNewValue > model.all.count {
            model.all.append(0.6)
            slider.append(0.6)
        }
        
        numOfSliders = sliderNewValue
    }
    
    private func removeGradient(index: Int) {
        slider.remove(at: index)
        model.all.remove(at: index)
    }
}

struct ButtonsView: View {
    @EnvironmentObject var model: ColorsModel
    @State private var colorSettings: Bool = false
    @State private var hiddenView: Bool = false
    @State private var showingSheet = false
    var actionScreenshot: (() -> Void)
    
    var body: some View {
        HStack {
            if colorSettings {
                VStack {
                    Button(action: {
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .padding([.leading, .top, .trailing], 18)
                            .padding(.bottom, 8)
                    })
                    .sheet(isPresented: $showingSheet) {
                        SheetView().presentationDetents([.height(332)]).environmentObject(model)
                    }
                    
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding([.leading, .top, .trailing], 18)
                        .padding(.bottom, 8)
                        .overlay {
                            ColorPicker("Set primary color", selection: $model.primaryColor, supportsOpacity: false)
                                .labelsHidden().opacity(0.015).onDisappear()
                        }
                    
                    Image(systemName: "paintbrush.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding([.leading, .top, .trailing], 18)
                        .padding(.bottom, 8)
                        .overlay {
                            ColorPicker("Set background color", selection: $model.backgroundColor, supportsOpacity: false)
                                .labelsHidden().opacity(0.015)
                        }
                    
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding(18)
                        .onTapGesture {
                            colorSettings.toggle()
                        }
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
                    .padding(.bottom, colorSettings ? 150 : 0)
                    .opacity(hiddenView ? 0 : 100)
                    .animation(.easeIn, value: colorSettings)
            } else {
                ZStack{
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding(18)
                        .onTapGesture {
                            colorSettings.toggle()
                        }
                }
                .background(.ultraThinMaterial)
                .cornerRadius(50)
                .opacity(hiddenView ? 0 : 100)
                .animation(.default, value: colorSettings)
            }
            
            Spacer()
            
            Circle()
                .colorInvert()
                .opacity(0.2)
                .overlay {
                    Image(systemName: "camera.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .blendMode(.difference)
                        .padding(16)
                        .onTapGesture {
                            hiddenView = true
                            actionScreenshot()
                            hiddenView = false
                        }
                }
        }
        .frame(width: 320, height: 50)
        .padding(.bottom, 10)
        //.opacity(hiddenView ? 0 : 100)
    }
}

typealias ScreenshotMakerClosure = (ScreenshotMaker) -> Void

struct ScreenshotMakerView: UIViewRepresentable {
    let closure: ScreenshotMakerClosure

    init(_ closure: @escaping ScreenshotMakerClosure) {
        self.closure = closure
    }

    func makeUIView(context: Context) -> ScreenshotMaker {
        let view = ScreenshotMaker(frame: CGRect.zero)
        return view
    }

    func updateUIView(_ uiView: ScreenshotMaker, context: Context) {
        DispatchQueue.main.async {
            closure(uiView)
        }
    }
}

class ScreenshotMaker: UIView {
    /// Takes the screenshot of the superview of this superview
    /// - Returns: The UIImage with the screenshot of the view
    func screenshot() -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
//        guard let containerView = self.superview?.superview,
//              let containerSuperview = containerView.superview else { return nil }
//        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
//
//        let screenshot = renderer.image { (context) in
//            containerSuperview.layer.render(in: context.cgContext)
//        }
//        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          
        
        return UIImage()
    }
}

extension View {
    func screenshotView(_ closure: @escaping ScreenshotMakerClosure) -> some View {
        let screenshotView = ScreenshotMakerView(closure)
        return overlay(screenshotView.allowsHitTesting(false))
    }
}

#if DEBUG
struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView(actionScreenshot: {}).environmentObject(ColorsModel())
    }
}
#endif
