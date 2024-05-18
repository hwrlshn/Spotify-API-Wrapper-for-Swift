//
//  AlbumModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 15.05.24.
//

import Foundation

public struct AlbumModel: Decodable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]?
    let externalUrls: CommonExternalUrls
    let href: String
    let id: String
    let images: [CommonImages]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let restrictions: CommonRestrictions?
    let type: String
    let uri: String
    let artists: [CommonArtists]
    let tracks: AlbumTracks
    let copyrights: [AlbumCopyrights]
    let externalIds: CommonExternalIds
    let genres: [String]
    let label: String
    let popularity: Int
    
    enum CodingKeys: String, CodingKey {
        case href, id, popularity, label, genres,
             copyrights, tracks, images, name, restrictions,
             type, uri, artists
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case externalIds = "external_ids"
    }
    
}

struct AlbumTracks: Decodable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [AlbumItems]
}

struct AlbumItems: Decodable {
    let artists: [CommonArtists]
    let availableMarkets: [String]?
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: CommonExternalUrls
    let href: String
    let id: String
    let isPlayable: Bool?
    let linkedFrom: AlbumLinkedFrom?
    let restrictions: CommonRestrictions?
    let name: String
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String
    let isLocal: Bool
    
    enum CodingKeys: String, CodingKey {
        case artists, explicit, href, id, restrictions, name, type, uri
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case externalUrls = "external_urls"
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case isLocal = "is_local"
    }
    
}

struct AlbumLinkedFrom: Decodable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case href, id, type, uri
        case externalUrls = "external_urls"
    }
    
}

struct AlbumCopyrights: Decodable {
    let text: String
    let type: String
}
