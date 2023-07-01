//
//  ActionsUIView.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

struct ActionsUIView: View {
    @EnvironmentObject var model: ColorsModel
    @State private var colorSettings: Bool = false
    @State private var showingSheet = false
    var hiddeView: (() -> Void)
    
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
                    
                    Button(action: {
                        colorSettings.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .padding(18)
                    })
                    .cornerRadius(50)
                }
                .background(.ultraThinMaterial)
                .cornerRadius(50)
                .padding(.bottom, colorSettings ? 150 : 0)
                .animation(.easeIn, value: colorSettings)
            } else {
                Button(action: {
                    colorSettings.toggle()
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding(18)
                })
                .background(.ultraThinMaterial)
                .cornerRadius(50)
                .animation(.default, value: colorSettings)
            }
            
            Spacer()
            
            Button(action: {
                hiddeView()
            }, label: {
                Image(systemName: "eye.slash.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                    .padding(18)
            })
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .animation(.default, value: colorSettings)
        }
        .frame(width: 320, height: 50)
        .padding(.bottom, 10)
    }
}

#if DEBUG
struct ActionsUIView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsUIView(hiddeView: {}).environmentObject(ColorsModel())
    }
}
#endif
