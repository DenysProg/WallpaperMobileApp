//
//  WallpaperMobileAppApp.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

@main
struct WallpaperMobileAppApp: App {
    @StateObject var loadingViewModel: LoadPhotoViewModel = LoadPhotoViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(loadingViewModel)
        }
    }
}
