//
//  ButtonsView.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

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
                        AdjustGradientView().presentationDetents([.height(332)]).environmentObject(model)
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
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let containerView = self.superview?.superview,
              let containerSuperview = containerView.superview else { return nil }
        
        var newFrame: CGRect = containerView.frame
        newFrame.size.width -= 100
        newFrame.size.height -= 100
        newFrame.origin.y = 50
        newFrame.origin.x = 50
        let renderer = UIGraphicsImageRenderer(bounds: newFrame)

        let screenshot = renderer.image { (context) in
            containerSuperview.layer.render(in: context.cgContext)
        }
        
        
        
        
        let inputImage = CIImage(cgImage: (screenshot.cgImage)!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(130, forKey: "inputRadius")
        let blurred = filter?.outputImage

        var newImageSize: CGRect = (blurred?.extent)!
        newImageSize.origin.x = 0//+= (newImageSize.size.width - (screenshot.size.width)) / 2
        newImageSize.origin.y = 0//+= (newImageSize.size.height - (screenshot.size.height)) / 2
        newImageSize.size.width = UIScreen.main.bounds.width * 2.5 // = (screenshot.size)
        newImageSize.size.height = UIScreen.main.bounds.height * 2.5

        let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
        let context: CIContext = CIContext.init(options: nil)
        let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
        let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
        //UIImageWriteToSavedPhotosAlbum(blurredImage, nil, nil, nil)
        
        //UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: screenshot)
         currentFilter!.setValue(beginImage, forKey: "inputImage")
         currentFilter!.setValue(130, forKey: "inputRadius")

         let cropFilter = CIFilter(name: "CICrop")
         cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
         cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

         let output = cropFilter!.outputImage
         let cgimg2 = context.createCGImage(output!, from: output!.extent)
         let processedImage = UIImage(cgImage: cgimg2!)
        
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
        return processedImage //UIImage(ciImage: blurred!)
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
