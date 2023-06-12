//
//  LoadPhotoViewModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import UIKit
import Foundation
import Combine

class DownloadingImagesViewModel: ObservableObject {
    @Published var photoArray: [PhotoModel] = []
    @Published var collectionArray: [CollectionModel] = []
    @Published var relatedCollectionArray: [CollectionModel] = []
    @Published var photo: PhotoModel? = nil
    @Published var collectionPhotosArray: [CollectionPhotosModel] = []
    @Published var randomoPhotosArray: [CollectionPhotosModel] = []
    private var photoCollectionId: String? = nil
    
    private var frameworkPath: String = {
    #if TARGET_OS_SIMULATOR
        "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks"
    #else
        "/System/Library/PrivateFrameworks"
    #endif
    }()
    
    @Published var offset: Int = 0
    
    private let dataService = PhotoModelDataService.instatse
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addPhotoSubscribers()
    }
    
    func addPhotoSubscribers() {
        dataService.$photoModel
            .sink { [weak self] (returnedPhotoModels) in
                self?.photoArray = returnedPhotoModels
            }
            .store(in: &cancellables)
    }
    
    func loadRandomPhotos() async {
        guard let data = try? await dataService.downloadRandomPhoto() else { return }
        
        await MainActor.run {
            self.randomoPhotosArray = data
        }
    }
    
    func loadCollectionPhotos(id: String?) async {
        self.photoCollectionId = id
        guard
            let id = id,
            let data = try? await dataService.downloadCollectionPhotos(id: id) else { return }
        
        await MainActor.run {
            self.collectionPhotosArray = data
        }
    }
    
    func loadCollectionData() async {
        guard let data = try? await dataService.downloadCollectionData() else { return }
        
        await MainActor.run {
            self.collectionArray = data
        }
    }
    
    func loadRelatedCollectionData(id: String?) async {
        guard
            let id = id,
            let data = try? await dataService.downloadRelatedPhotoCollection(id: id) else { return }
        
        await MainActor.run {
            self.relatedCollectionArray = data
        }
    }
    
    func loadPhotoData() {
        dataService.page += 1
        dataService.downloadData()
    }
    
    func loadCollectionData() {
        dataService.collectionPage += 1
        Task {
            await loadCollectionData()
        }
    }
    
    func loadCollectionPhotos() {
        dataService.photosPage += 1
        guard let id = photoCollectionId else { return }
        Task {
            await loadCollectionPhotos(id: id)
        }
    }
    
    func clearCollectionPhotos() {
        collectionPhotosArray = []
        dataService.collectionPhotos = []
    }
}

extension DownloadingImagesViewModel {
    func setWallpaper(location: WallpaperLoction, image: UIImage) {

        // load private frameworks
        let sbFoundation = dlopen(frameworkPath + "/SpringBoardFoundation.framework/SpringBoardFoundation", RTLD_LAZY)
        let sbUIServices = dlopen(frameworkPath + "/SpringBoardUIServices.framework/SpringBoardUIServices", RTLD_LAZY)

        defer {
            dlclose(sbFoundation)
            dlclose(sbUIServices)
        }

        guard
            let SBFWallpaperOptions = NSClassFromString("SBFWallpaperOptions"),
            let pointer = dlsym(sbUIServices, "SBSUIWallpaperSetImages"),
            let SBSUIWallpaperSetImages = unsafeBitCast(
                pointer,
                to: (@convention(c) (_: NSDictionary, _: NSDictionary, _: Int, _: Int) -> Int)?.self
            )
        else {
            return
        }

        // set wallpaper options
        let setModeSelector = NSSelectorFromString("setWallpaperMode:")
        let setParallaxSelector = NSSelectorFromString("setParallaxFactor:")
        let setNameSelector = NSSelectorFromString("setName:")

        let lightOptions = SBFWallpaperOptions.alloc()
        invokeInt(setModeSelector, lightOptions, 1)
        invokeDouble(setParallaxSelector, lightOptions, 1)
        invokeAny(setNameSelector, lightOptions, NSString("1234.WallpaperLoader Light"))

        let darkOptions = SBFWallpaperOptions.alloc()
        invokeInt(setModeSelector, darkOptions, 2)
        invokeDouble(setParallaxSelector, darkOptions, 1)
        invokeAny(setNameSelector, darkOptions, NSString("1234.WallpaperLoader Dark"))

        let imagesDict = [
            "light": image,
            "dark": image
        ]

        let optionsDict = [
            "light" : lightOptions,
            "dark": darkOptions
        ]

        // set wallpaper
        _ = SBSUIWallpaperSetImages(
            NSDictionary(dictionary: imagesDict),
            NSDictionary(dictionary: optionsDict),
            location.rawValue,
            UIUserInterfaceStyle.dark.rawValue
        )
    }
}
