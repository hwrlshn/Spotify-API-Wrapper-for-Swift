//
//  KeychainKeys.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

enum KeychainKeys: String, EnumWithKeys {
    
    var str: String { return self.rawValue }
    
    case cliendId       = "SAPIW.cliedID"
    case redirectUri    = "SAPIW.redirectURI"
    case codeVerifier   = "SAPIW.codeVerifier"
    case accessToken    = "SAPIW.access_token"
    case expiresIn      = "SAPIW.expires_in"
    case refreshToken   = "SAPIW.refresh_token"
    case tokenType      = "SAPIW.token_type"
}
