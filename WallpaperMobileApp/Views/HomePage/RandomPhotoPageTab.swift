//
//  RandomPhotoPageTab.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct RandomPhotoPageTab: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    private let adaptiveColums = [GridItem(.adaptive(minimum: 170))]
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.randomoPhotosArray.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    ScrollView {
                        LazyVGrid(columns: adaptiveColums, spacing: 20) {
                            ForEach(viewModel.randomoPhotosArray) { photo in
                                CollectionPhotoView(photo: photo)
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.loadRandomPhotos()
                        }
                    }
                }
            }
            .navigationTitle("Random Photos")
            .onAppear {
                Task {
                    await viewModel.loadRandomPhotos()
                }
            }
            .onDisappear {
                viewModel.randomoPhotosArray = []
            }
        }
    }
}

struct RandomPhotoPageTab_Previews: PreviewProvider {
    static var previews: some View {
        RandomPhotoPageTab()
    }
}
