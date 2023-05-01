//
//  HomePageTab.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

struct HomePageTab: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.photoArray) { photo in
                    DownloadingImagesRow(photo: photo)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
}

struct HomePageTab_Previews: PreviewProvider {
    @Binding var taab: Int
    
    static var previews: some View {
        HomePageTab()
            .environmentObject(DownloadingImagesViewModel())
    }
}
