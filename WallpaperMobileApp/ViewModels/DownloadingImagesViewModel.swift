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
    @Published var photo: PhotoModel? = nil
    
    private var frameworkPath: String = {
    #if TARGET_OS_SIMULATOR
        "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks"
    #else
        "/System/Library/PrivateFrameworks"
    #endif
    }()
    
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
