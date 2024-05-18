//
//  AlbumTracksModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 16.05.24.
//

import Foundation

public struct AlbumTracksModel: Decodable {
    let href: String
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
    let items: [AlbumTracksItems]
}

struct AlbumTracksItems: Decodable {
    let artists: [AlbumTracksArtists]
    let availableMarkets: [String]?
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isPlayable: Bool
    let linkedFrom: AlbumTracksLinkedFrom?
    let restrictions: CommonRestrictions?
    let name: String
    let previewUrl: String
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

struct AlbumTracksArtists: Decodable {
    let externalUrls: ExternalUrls
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

struct AlbumTracksLinkedFrom: Decodable {
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
