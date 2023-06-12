//
//  DownloadingCollectionImageView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct DownloadingCollectionImageView: View {
    @StateObject var loader: ImageLoadingViewModel
    
    init(url: String, key: String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        if loader.isLoading {
            ZStack {
                Rectangle()
                    .frame(width: 170, height: 170)
                    .foregroundColor(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                ProgressView()
            }
        } else if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
    }
}

struct DownloadingCollectionImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingCollectionImageView(url: placeHolderImage, key: "3")
            .frame(height: 300)
            .previewLayout(.sizeThatFits)
    }
}
