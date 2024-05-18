//
//  SpotifyAuthorization.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import UIKit
import CryptoKit

@available(iOS 13.0, *)
internal final class SpotifyAuthorization: HTTPClient {
    
    internal static let shared: SpotifyAuthorization = .init()
    
    private init() { }
    
    // MARK: - Request Code
    
    func startAuthorization(clientID: String, redirectUri: String) async -> Result<RequestCodeModel, HTTPRequestError> {
        let codeVerifier = String.generateRandomString(with: 64)
        
        KeychainService.shared.save(value: clientID, forKey: KeychainKeys.cliendId.str)
        KeychainService.shared.save(value: redirectUri, forKey: KeychainKeys.redirectUri.str)
        KeychainService.shared.save(value: codeVerifier, forKey: KeychainKeys.codeVerifier.str)
        
        let result = await sendRequest(
            endpoint: AuthorizationEndpoint.requestCode(clientID: clientID, redirectUri: redirectUri),
            responseModel: RequestCodeModel.self)
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    // MARK: - Request an access token
    
    func getAccessToken(code: String) async -> Result<RequestAccessTokenModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AuthorizationEndpoint.requestAccessToken(code: code),
            responseModel: RequestAccessTokenModel.self)
        switch result {
        case .success(let success):
            let expiresIn = Date().timeIntervalSince1970 + Double(success.expiresIn)
            KeychainService.shared.save(
                value: expiresIn,
                forKey: KeychainKeys.expiresIn.str)
            KeychainService.shared.save(
                value: success.accessToken,
                forKey: KeychainKeys.accessToken.str)
            KeychainService.shared.save(
                value: success.refreshToken,
                forKey: KeychainKeys.refreshToken.str)
            KeychainService.shared.save(
                value: success.tokenType,
                forKey: KeychainKeys.tokenType.str)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    // MARK: - Refresh access token
    
    func refreshToken() async -> Result<RefreshTokenModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AuthorizationEndpoint.refreshToken,
            responseModel: RefreshTokenModel.self)
        switch result {
        case .success(let success):
            let expiresIn = Date().timeIntervalSince1970 + Double(success.expiresIn)
            KeychainService.shared.save(
                value: expiresIn,
                forKey: KeychainKeys.expiresIn.str)
            KeychainService.shared.save(
                value: success.tokenType,
                forKey: KeychainKeys.tokenType.str)
            KeychainService.shared.save(
                value: success.refreshToken,
                forKey: KeychainKeys.refreshToken.str)
            KeychainService.shared.save(
                value: success.accessToken,
                forKey: KeychainKeys.accessToken.str)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
}
