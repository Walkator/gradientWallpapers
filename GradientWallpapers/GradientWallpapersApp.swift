//
//  GradientWallpapersApp.swift
//  GradientWallpapers
//
//  Created by Walkator on 4/6/23.
//

import SwiftUI

@main
struct GradientWallpapersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ColorsModel())
        }
    }
}
