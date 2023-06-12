//
//  CollectionPhotoView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct CollectionPhotoView: View {
    let photo: CollectionPhotosModel
    
    var body: some View {
        ZStack {
            DownloadingCollectionImageView(url: photo.urls?.small ?? placeHolderImage, key: photo.id ?? "")
        }
    }
}

struct CollectionPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionPhotoView(photo: CollectionPhotosModel(id: nil, urls: nil))
    }
}
