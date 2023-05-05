//
//  DownloadingImageView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI
import Foundation

struct DownloadingImageView: View {
    @StateObject var loader: ImageLoadingViewModel
    
    init(url: String, key: String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        if loader.isLoading {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .frame(height: 200)
                    .shadow(radius: 10)
                    .padding(10)
                ProgressView()
            }
            
        } else if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}

struct DownloadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImageView(url: placeHolderImage, key: "1")
            .frame(height: 300)
            .previewLayout(.sizeThatFits)
    }
}

