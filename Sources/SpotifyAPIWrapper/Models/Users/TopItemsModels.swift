//
//  TopItemsModels.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

// MARK: - Top Items Common Structures -

struct CommonExternalUrls: Decodable {
    let spotify: String
}

struct CommonImages: Decodable {
    let url: String
    let height: Int
    let width: Int
}

struct CommonFollowers: Decodable {
    let href: String?
    let total: Int
}

struct CommonItems: Decodable {
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let type: String
    let uri: String
    let genres: [String]
    let externalUrls: CommonExternalUrls
    let followers: CommonFollowers
    let images: [CommonImages]
    
    enum CodingKeys: String, CodingKey {
        case href, id, name, popularity, type, uri, genres, followers, images
        case externalUrls = "external_urls"
    }
}

struct CommonRestrictions: Decodable {
    let reason: String
}

struct CommonArtists: Decodable {
    let externalUrls: CommonExternalUrls
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case href, id, name, type, uri
        case externalUrls = "external_urls"
    }
}

struct CommonExternalIds: Decodable {
    let isrc: String?
    let ean: String?
    let upc: String?
}


// MARK: - Top Items Artists Structures -

public struct TopItemsArtistsModel: Decodable {
    let href: String
    let limit: Int
    let next: String
    let offset: Int
    let previous: String
    let total: Int
    let items: [CommonItems]?
}

// MARK: - Top Items Tracks Structures -

public struct TopItemsTracksModel: Decodable {
    let href: String
    let limit: Int
    let next: String
    let offset: Int
    let previous: String
    let total: Int
    let items: [ItemsTracks]?
}

struct ItemsTracks: Decodable {
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let previewUrl: String
    let trackNumber: Int
    let type: String
    let uri: String
    let isLocal: Bool
    let availableMarkets: [String]
    let album: TracksAlbum
    let artists: [CommonArtists]
    let externalIds: CommonExternalIds
    let externalUrls: CommonExternalUrls
    
    enum CodingKeys: String, CodingKey {
        case explicit, href, id, name, popularity, type, uri, album, artists
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case isLocal = "is_local"
        case availableMarkets = "available_markets"
    }
}

struct TracksAlbum: Decodable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: CommonExternalUrls
    let href: String
    let id: String
    let images: [CommonImages]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let type: String
    let uri: String
    let artists: [CommonArtists]
    
    enum CodingKeys: String, CodingKey {
        case href, id, name, type, uri, artists, images
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
    }
    
}
