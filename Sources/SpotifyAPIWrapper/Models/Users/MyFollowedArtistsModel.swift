//
//  MyFollowedArtistsModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 14.05.24.
//

import Foundation

public struct MyFollowedArtistsModel: Decodable {
    let artists: ArtistsModel
}

struct ArtistsModel: Decodable {
    let href: String
    let limit: Int
    let next: String
    let total: Int
    let cursors: FollowedArtistsCursors
    let items: [CommonItems]
}

struct FollowedArtistsCursors: Decodable {
    let after: String?
    let before: String?
}

