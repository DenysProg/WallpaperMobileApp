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
    let color: String
    let blur_hash: String
    let likes: Int
    let liked_by_user: Bool
    let description: String
    let user: UserModel
    let current_user_collections: CurrentCollectionsModel
}

struct CurrentCollectionsModel: Identifiable, Codable {
    let id: Int
    let title: String
    let published_at: String
    let last_collected_at: String
    let updated_at: String
    let cover_photo: String
}

