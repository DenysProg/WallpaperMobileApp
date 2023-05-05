//
//  PhotoModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation

struct PhotoModel: Identifiable, Codable {
    let id: String
    let created_at: String
    let updated_at: String
    let width: Int
    let height: Int
    let alt_description: String?
    let `description`: String?
    let urls: UrlsModel?
    let links: PhotoLinksModel?
    let user: UserModel?
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
