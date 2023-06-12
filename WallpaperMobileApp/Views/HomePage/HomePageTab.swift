//
//  HomePageTab.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import SwiftUI

struct HomePageTab: View {
    @EnvironmentObject private var viewModel: DownloadingImagesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.photoArray.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    VStack {
                        List {
                            ForEach(viewModel.photoArray) { photo in
                                Button {
                                    viewModel.photo = photo
                                } label: {
                                    DownloadingImagesRow(photo: photo)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .listRowSeparator(.hidden)
                            
                            if viewModel.offset == viewModel.photoArray.count {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding(.vertical)
                                        .onAppear {
                                            viewModel.loadPhotoData()
                                        }
                                    Spacer()
                                }
                                
                            } else {
                                GeometryReader { reader -> Color in
                                    let minY = reader.frame(in: .global).minY
                                    let height = UIScreen.main.bounds.height / 1.3
                                    
                                    if !viewModel.photoArray.isEmpty && minY < height {
                                        DispatchQueue.main.async {
                                            viewModel.offset = viewModel.photoArray.count
                                        }
                                    }
                                    
                                    return Color.clear
                                }
                                .frame(width: 20, height: 20)
                            }
                            
                        }
                        .listStyle(.plain)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Images")
            .sheet(item: $viewModel.photo, onDismiss: nil) { photo in
                DetailsPhotoView(url: photo.urls?.regular ?? placeHolderImage, key: photo.id ?? "", photo: photo)
            }
        }
    }
}

struct HomePageTab_Previews: PreviewProvider {
    @Binding var taab: Int
    
    static var previews: some View {
        HomePageTab()
            .environmentObject(DownloadingImagesViewModel())
    }
}
