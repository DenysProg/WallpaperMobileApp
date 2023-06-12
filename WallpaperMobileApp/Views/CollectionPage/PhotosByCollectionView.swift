//
//  PhotosByCollectionView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct PhotosByCollectionView: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    let itemCollection: CollectionModel
    
    private let adaptiveColums = [GridItem(.adaptive(minimum: 170))]
    
    var body: some View {
        VStack {
            if viewModel.collectionPhotosArray.isEmpty {
                ProgressView()
                    .padding(.top, 30)
            } else {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: adaptiveColums, spacing: 20) {
                            ForEach(viewModel.collectionPhotosArray) { photo in
                                CollectionPhotoView(photo: photo)
                            }
                        }
                    }
                    
                    if viewModel.offset == viewModel.collectionPhotosArray.count {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding(.vertical)
                                .onAppear {
                                    viewModel.loadCollectionPhotos()
                                }
                            Spacer()
                        }
                    } else {
                        GeometryReader { reader -> Color in
                            let minY = reader.frame(in: .global).minY
                            let height = UIScreen.main.bounds.height / 1.3
                            
                            if !viewModel.collectionPhotosArray.isEmpty && minY < height {
                                DispatchQueue.main.async {
                                    viewModel.offset = viewModel.collectionPhotosArray.count
                                }
                            }
                            
                            return Color.clear
                        }
                        .frame(width: 20, height: 20)
                    }
                  
                }
            }
        }
        .navigationTitle("Collection Photos")
        .onAppear {
            Task {
                await viewModel.loadCollectionPhotos(id: itemCollection.id ?? "")
            }
        }
        .onDisappear {
            viewModel.clearCollectionPhotos()
        }
    }
}

struct PhotosByCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosByCollectionView(itemCollection: CollectionModel(id: nil, title: nil, cover_photo: nil))
    }
}
