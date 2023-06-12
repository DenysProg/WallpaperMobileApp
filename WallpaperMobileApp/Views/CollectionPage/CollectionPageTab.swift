//
//  CollectionPageTab.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 12.06.2023.
//

import SwiftUI

struct CollectionPageTab: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.collectionArray.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    VStack {
                        List {
                            ForEach(viewModel.collectionArray) { collection in
                                Section(collection.title ?? "") {
                                    NavigationLink {
                                        RelatedCollectionPhotoView(itemCollection: collection)
                                    } label: {
                                        DownloadingImagesRow(photo: PhotoModel(model: collection))
                                            .listRowSeparator(.hidden)
                                    }
                                    .listRowSeparator(.hidden)
                                }
                            }
                            
                            if viewModel.offset == viewModel.collectionArray.count {
                                HStack(alignment: .center) {
                                    Spacer()
                                    ProgressView()
                                        .frame(alignment: .center)
                                        .onAppear {
                                            viewModel.loadCollectionData()
                                        }
                                    Spacer()
                                }
                            } else {
                                GeometryReader { reader -> Color in
                                    let minY = reader.frame(in: .global).minY
                                    let height = UIScreen.main.bounds.height / 1.3
                                    
                                    if !viewModel.collectionArray.isEmpty && minY < height {
                                        DispatchQueue.main.async {
                                            viewModel.offset = viewModel.collectionArray.count
                                        }
                                    }
                                    
                                    return Color.clear
                                }
                                .frame(width: 20, height: 20, alignment: .center)
                            }
                        }
                        .listStyle(GroupedListStyle())
                    }
                }
            }
            .navigationTitle("Collections")
        }
        .onAppear {
            Task {
                await viewModel.loadCollectionData()
            }
        }
    }
}

struct CollectionPageTab_Previews: PreviewProvider {
    static var previews: some View {
        CollectionPageTab()
    }
}
