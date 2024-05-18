//
//  MyProfileModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

public struct MyProfileModel: Decodable {
    let country: String
    let displayName: String
    let email: String
    let href: String
    let id: String
    let product: String
    let type: String
    let uri: String
    
    let explicitContent: ExplicitContent
    let externalUrls: ExternalUrls
    let followers: Followers
    let images: [Images]
    
    enum CodingKeys: String, CodingKey {
        case country, email, href, id, product, type, uri, followers, images
        case displayName = "display_name"
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
    }
}

struct ExplicitContent: Decodable {
    let filterEnabled: Bool
    let filterLocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

struct ExternalUrls: Decodable {
    let spotify: String
}

struct Followers: Decodable {
    let href: String?
    let total: Int
}

struct Images: Decodable {
    let url: String
    let height: Int
    let width: Int
}
