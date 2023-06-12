//
//  RelatedCollectionPhotoView.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct RelatedCollectionPhotoView: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    let itemCollection: CollectionModel
    
    var body: some View {
        VStack {
            if viewModel.relatedCollectionArray.isEmpty {
                ProgressView()
                    .padding(.top, 30)
            } else {
                VStack {
                    List {
                        ForEach(viewModel.relatedCollectionArray) { collection in
                            Section(collection.title ?? "") {
                                NavigationLink {
                                    PhotosByCollectionView(itemCollection: collection)
                                } label: {
                                    DownloadingImagesRow(photo: PhotoModel(model: collection))
                                        .listRowSeparator(.hidden)
                                }
                                
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
            }
        }
        .navigationTitle("Related Collections")
        .onAppear {
            Task {
                await viewModel.loadRelatedCollectionData(id: itemCollection.id ?? "")
            }
        }
        .onDisappear {
            viewModel.relatedCollectionArray = []
        }
    }
}

struct RelatedCollectionPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        RelatedCollectionPhotoView(itemCollection: CollectionModel(id: nil, title: nil, cover_photo: nil))
    }
}
