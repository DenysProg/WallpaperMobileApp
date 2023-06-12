//
//  DownloadingImagesRow.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

struct DownloadingImagesRow: View {
    let photo: PhotoModel
    
    var body: some View {
        ZStack {
            DownloadingImageView(url: photo.urls?.small ?? placeHolderImage, key: photo.id ?? "")
                .listRowSeparator(.hidden)
        }
    }
}

struct DownloadingImagesRow_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImagesRow(photo: PhotoModel(id: "1", created_at: "", updated_at: "", width: 20, height: 30, alt_description: "", description: "", urls: nil, links: nil, user: nil))
            .frame(height: 200)
            .frame(width: 300)
            .previewLayout(.sizeThatFits)
    }
}
