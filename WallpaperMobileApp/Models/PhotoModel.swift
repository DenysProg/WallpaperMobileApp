//
//  PhotoModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation

struct PhotoModel: Identifiable, Codable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let width: Int?
    let height: Int?
    let alt_description: String?
    var `description`: String?
    let urls: UrlsModel?
    let links: PhotoLinksModel?
    let user: UserModel?
    
    init(id: String?, created_at: String?, updated_at: String?, width: Int?, height: Int?, alt_description: String?, `description`: String?, urls: UrlsModel?, links: PhotoLinksModel?, user: UserModel?) {
        self.id = id
        self.created_at = created_at
        self.updated_at = updated_at
        self.width = width
        self.height = height
        self.alt_description = alt_description
        self.description = description
        self.urls = urls
        self.links = links
        self.user = user
    }
    
    init(model: CollectionModel) {
        self.id = model.id
        self.urls = model.cover_photo?.urls
        self.description = nil
        self.created_at = nil
        self.updated_at = nil
        self.width = nil
        self.height = nil
        self.alt_description = nil
        self.description = nil
        self.links = nil
        self.user = nil
    }
    
    init(model: CollectionPhotosModel) {
        self.id = model.id
        self.urls = model.urls
        self.description = nil
        self.created_at = nil
        self.updated_at = nil
        self.width = nil
        self.height = nil
        self.alt_description = nil
        self.description = nil
        self.links = nil
        self.user = nil
    }
}

struct UrlsModel: Codable {
    let full: String
    let regular: String
    let thumb: String
    let small: String
}

struct CurrentCollectionsModel: Identifiable, Codable {
    let id: Int
    let title: String
    let published_at: String
    let last_collected_at: String
    let updated_at: String
    let cover_photo: String
}

struct PhotoLinksModel: Codable {
    let `self`: String
    let html: String
    let download: String
    let download_location: String
}

struct UserModel: Codable {
    let id: String
    let name: String
    let username: String
    let profile_image: ProfileImageModel?
}

struct ProfileImageModel: Codable {
    let small: String
    let medium: String
    let large: String
}
