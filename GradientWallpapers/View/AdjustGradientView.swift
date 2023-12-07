//
//  AdjustGradientView.swift
//  GradientWallpapers
//
//  Created by Walkator on 12/6/23.
//

import SwiftUI

struct AdjustGradientView: View {
    @EnvironmentObject var model: ColorsModel
    @State private var slider: [Double] = [0, 0, 0, 0, 0, 0, 0]
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
                        .foregroundColor(Color(UIColor(model.primaryColor).colorWithBrightness(slider.getElement(index) ?? 0)))
                        .padding(.leading, 24)
                        .padding(.trailing)
                    
                    HStack {
                        Slider(value: $slider[index], in: 0.1...2.8, onEditingChanged: { data in
                            changeColor(index, brightness: slider.getElement(0) ?? 0)
                        })
                        .padding([.trailing], index < 3 ? 24 : 0)
                        .tint(model.primaryColor)
                        
                        if index >= 3 {
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
            
            HStack {
                Button(action: {
                    model.randomMovement = true
                }) {
                    Text("Random Movements")
                        
                }.buttonStyle(.bordered)
                .cornerRadius(50)
                .tint(model.primaryColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(model.randomMovement ? model.primaryColor : .clear, lineWidth: 2)
                )
                
                Button(action: {
                    model.randomMovement = false
                }) {
                    Text("Static")
                        
                }.buttonStyle(.bordered)
                .cornerRadius(50)
                .tint(model.primaryColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(!model.randomMovement ? model.primaryColor : .clear, lineWidth: 2)
                )
            }
            
            Spacer()
            
            Button(action: {
                addNewGradient()
            }, label: {
                Text("Add more rings")
            }).opacity(numOfSliders == 7 ? 0 : 100)
                .tint(model.primaryColor)
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
        guard slider.getElement(index) != nil else { return }
        slider.remove(at: index)
        model.all.remove(at: index)
        numOfSliders -= 1
    }
}

#if DEBUG
struct AdjustGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustGradientView().environmentObject(ColorsModel())
    }
}
#endif
