//
//  DetailsPhotoView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 02.05.2023.
//

import SwiftUI

enum WallpaperLoction: Int {
    case lockScreen = 1
    case homeScreen = 2
    case both = 3
}

struct DetailsPhotoView: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    @StateObject var loader: ImageLoadingViewModel
    @State private var showingLocationSelect: Bool = false
    @State private var lightImage = UIImage(named: "placeholder")!
    let photo: PhotoModel
    
    init(url: String, key: String, photo: PhotoModel) {
        self.photo = photo
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }

    var body: some View {
        ScrollView {
            if loader.isLoading {
                VStack {
                    ProgressView()
                        .padding(.top, 50)
                }
            } else if let image = loader.image  {
                VStack {
                    getImageSection(image: image)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileUserSection(url: photo.user?.profile_image?.medium ?? "", key: photo.user?.id ?? "", photo: photo)
                        Divider()
                        descriptionSection
                        Divider()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Button("Set Wallpaper") {
                        showingLocationSelect = true
                    }
                    .actionSheet(isPresented: $showingLocationSelect) {
                        ActionSheet(
                            title: Text("Select location"),
                            buttons: [
                                .default(Text("Home Screen")) {
                                    if let image = loader.image {
                                        viewModel.setWallpaper(location: .homeScreen, image: image)
                                    }
                                },
                                .default(Text("Lock Screen")) {
                                    if let image = loader.image {
                                        viewModel.setWallpaper(location: .lockScreen, image: image)
                                    }
                                },
                                .default(Text("Both")) {
                                    if let image = loader.image {
                                        viewModel.setWallpaper(location: .both, image: image)
                                    }
                                },
                                .cancel()
                            ]
                        )
                    }
                    .frame(width: 250)
                    .foregroundColor(.white)
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
                }
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment:.topLeading, content: {
            backButton
        })
    }
   
}

struct DetailsPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPhotoView(url: placeHolderImage, key: "2", photo: PhotoModel(id: "", created_at: "", updated_at: "", width: 0, height: 0, alt_description: "", description: "", urls: nil, links: nil, user: nil))
    }
}

extension DetailsPhotoView {
    private func getImageSection(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
            .frame(height: 350)
            .clipped()
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(photo.description ?? "Description:")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(photo.alt_description ?? "No description yet")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let url = URL(string: photo.links?.html ?? "") {
                Link("Read more from website", destination: url)
                    .font(.subheadline)
                    .tint(.blue)
            }
        }
    }
    
    private var backButton: some View {
        Button {
            viewModel.photo = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}
