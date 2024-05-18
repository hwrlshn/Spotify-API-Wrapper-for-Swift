//
//  MySavedAlbumsModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 17.05.24.
//

import Foundation

public struct MySavedAlbumsModel: Decodable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [MySavedAlbumsItems]
}

struct MySavedAlbumsItems: Decodable {
    let addedAt: String
    let album: AlbumModel
    
    enum CodingKeys: String, CodingKey {
        case album
        case addedAt = "added_at"
    }
}
