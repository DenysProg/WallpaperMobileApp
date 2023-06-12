//
//  CollectionModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 31.05.2023.
//

import Foundation

struct CollectionModel: Identifiable, Codable {
    let id: String?
    let title: String?
    let cover_photo: CoverPhotoModel?
}

struct CoverPhotoModel: Codable {
    let id: String
    let urls: UrlsModel
}

struct CollectionPhotosModel: Identifiable, Codable {
    let id: String?
    let urls: UrlsModel?
}
