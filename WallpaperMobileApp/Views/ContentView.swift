//
//  ContentView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView {
            HomePageTab()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Photos")
                }
            Text("Random category")
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Random category")
                }
            Text("Category")
                .tabItem {
                    Image(systemName: "photo.stack")
                    Text("Category")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DownloadingImagesViewModel())
    }
}


