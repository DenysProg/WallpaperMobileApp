//
//  HomePageTab.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

struct HomePageTab: View {
    @EnvironmentObject private var viewModel: LoadPhotoViewModel
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.photoArray) { photo in
                    Text(photo.description)
                }
            }
        }
    }
    
}

struct HomePageTab_Previews: PreviewProvider {
    @Binding var taab: Int
    
    static var previews: some View {
        HomePageTab()
            .environmentObject(LoadPhotoViewModel())
    }
}
