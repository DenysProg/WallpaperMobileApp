//
//  UserModel.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 01.05.2023.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    let username: String
    let name: String
    let portfolio_url: String
    let bio: String
    let location: String
    let total_likes: Int
    let total_photos: Int
    let total_collections: Int
    let instagram_username: String
    let twitter_username: String
    let profile_image: ProfileImageModel
    let links: LinksModel
}

struct ProfileImageModel: Codable {
    let small: String
    let medium: String
    let large: String
}

struct LinksModel: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
}

