//
//  AuthorizationEndpoint.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation
import CryptoKit

enum AuthorizationEndpoint {
    case requestCode(clientID: String, redirectUri: String)
    case requestAccessToken(code: String)
    case refreshToken
}

@available(iOS 13.0, *)
extension AuthorizationEndpoint: Endpoint {
    
    var baseURL: URL? {
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .requestCode(let clientID, let redirectUri):
            let scopeProperties = [
                "user-read-private",
                "user-read-email",
                "user-top-read",
                "playlist-modify-public",
                "playlist-modify-private",
                "user-follow-read",
                "user-follow-modify",
                "user-library-read",
                "user-library-modify"
            ]
            let scope = scopeProperties.joined(separator: " ")
            let codeVerifier = KeychainService.shared.load(forKey: KeychainKeys.codeVerifier.str) as? String ?? ""
            let codeChallengeMethod = "S256"
            let hashed = sha256(plain: codeVerifier)
            let codeChallenge = base64encode(input: hashed)
            let queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.responseType.str, value: "code"),
                .init(name: QueryItemKeys.clientId.str, value: clientID),
                .init(name: QueryItemKeys.scope.str, value: scope),
                .init(name: QueryItemKeys.codeChallengeMethod.str, value: codeChallengeMethod),
                .init(name: QueryItemKeys.codeChallenge.str, value: codeChallenge),
                .init(name: QueryItemKeys.redirectUri.str, value: redirectUri)
            ]
            return queryItems
        case .requestAccessToken, .refreshToken:
            return []
        }
    }
    
    var path: String {
        switch self {
        case .requestCode(_, _):
            return "/authorize"
        case .requestAccessToken, .refreshToken:
            return "/api/token"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .requestCode(_, _):
            return .get
        case .requestAccessToken, .refreshToken:
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .requestCode(_, _):
            return nil
        case .requestAccessToken, .refreshToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .requestCode(_, _):
            return nil
        case .requestAccessToken(let code):
            guard let clientID: String = KeychainService.shared.load(forKey: KeychainKeys.cliendId.str) as? String,
                  let redirectUri: String = KeychainService.shared.load(forKey: KeychainKeys.redirectUri.str) as? String,
                  let codeVerifier = KeychainService.shared.load(forKey: KeychainKeys.codeVerifier.str) as? String
            else { return nil }
            let parameters: [String: Any] = [
                QueryItemKeys.clientId.str: clientID,
                QueryItemKeys.grantType.str: "authorization_code",
                QueryItemKeys.code.str: code,
                QueryItemKeys.redirectUri.str: redirectUri,
                QueryItemKeys.codeVerifier.str: codeVerifier
            ]
            return parameters
        case .refreshToken:
            guard let tokenForRefresh = KeychainService.shared.load(forKey: KeychainKeys.refreshToken.str)
            else {
                print("Can't found token for refreshing")
                return nil
            }
            guard let clientId = KeychainService.shared.load(forKey: KeychainKeys.cliendId.str)
            else { return nil }
            let parameters: [String: Any] = [
                QueryItemKeys.grantType.str: "refresh_token",
                QueryItemKeys.refreshToken.str: tokenForRefresh,
                QueryItemKeys.clientId.str: clientId
            ]
            return parameters
        }
    }
}

@available(iOS 13.0, *)
private extension AuthorizationEndpoint {
    
    func sha256(plain: String) -> Data {
        let inputData = Data(plain.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return Data(hashedData)
    }
    
    func base64encode(input: Data) -> String {
        let base64String = input.base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
        return base64String
    }
    
}
