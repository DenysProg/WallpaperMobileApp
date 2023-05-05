//
//  LoadPhotoViewModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation
import Combine

class DownloadingImagesViewModel: ObservableObject {
    @Published var photoArray: [PhotoModel] = []
    @Published var photo: PhotoModel? = nil
    
    @Published var offset: Int = 0
    
    private let dataService = PhotoModelDataService.instatne
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$photoModels
            .sink { [weak self] (returnedPhotoModels) in
                self?.photoArray = returnedPhotoModels
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        dataService.page += 1
        dataService.downloadData()
    }
}
