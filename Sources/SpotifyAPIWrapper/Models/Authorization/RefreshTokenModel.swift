//
//  RefreshTokenModel.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

struct RefreshTokenModel: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case scope
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
    
}
