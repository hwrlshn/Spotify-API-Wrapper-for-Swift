//
//  NewReleasesModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 19.05.24.
//

import Foundation

public struct NewReleasesModel: Decodable {
    let albums: NewReleaseAlbumModel
}

struct NewReleaseAlbumModel: Decodable {
    let href: String
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
    let items: [NewReleaseItems]
}

struct NewReleaseItems: Decodable {
    let albumType: String
    let artists: [CommonArtists]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let images: [CommonImages]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case artists, href, images, name, type, uri
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
    }
}
