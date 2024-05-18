//
//  QueryItemKeys.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

enum QueryItemKeys: String, EnumWithKeys {
    
    var str: String { return self.rawValue }
    
    case type, limit, offset, artist, ids, market
    
    case responseType           = "response_type"
    case clientId               = "client_id"
    case scope                  = "scope"
    case codeChallengeMethod    = "code_challenge_method"
    case codeChallenge          = "code_challenge"
    case redirectUri            = "redirect_uri"
    case grantType              = "grant_type"
    case code                   = "code"
    case codeVerifier           = "code_verifier"
    case refreshToken           = "refresh_token"
    case authorization          = "Authorization"
    case timeRange              = "time_range"
}
