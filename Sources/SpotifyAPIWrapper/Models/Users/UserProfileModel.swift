//
//  UserProfileModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 14.05.24.
//

import Foundation

public struct UserProfileModel: Decodable {
    let displayName: String
    let externalUrls: CommonExternalUrls
    let followers: CommonFollowers
    let href: String
    let id: String
    let images: [CommonImages]
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case followers, href, id, images, type, uri
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
