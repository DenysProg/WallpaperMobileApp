//
//  ProfileUserSection.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 02.05.2023.
//

import SwiftUI

struct ProfileUserSection: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    @StateObject var loader: ImageLoadingViewModel
    let photo: PhotoModel
    
    init(url: String, key: String, photo: PhotoModel) {
        self.photo = photo
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        if loader.isLoading {
            ProgressView()
        } else if let image = loader.image {
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(photo.user?.name ?? "No name")
                        .font(.headline)
                    Text(photo.user?.username ?? "No username")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ProfileUserSection_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserSection(url: placeHolderImage, key: "2", photo: PhotoModel(id: "", created_at: "", updated_at: "", width: 0, height: 0, alt_description: "", description: "", urls: nil, links: nil, user: nil))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
