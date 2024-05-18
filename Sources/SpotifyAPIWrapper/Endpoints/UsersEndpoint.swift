//
//  UsersEndpoint.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

public enum FollowType: String {
    case artist, user
}

enum UsersEndpoint {
    case getMyProfile
    case getMyTopArtistsItems(config: TopItemsConfig)
    case getMyTopTracksItems(config: TopItemsConfig)
    case getUserProfile(userID: String)
    case followPlaylist(playlistID: String, makeItPublic: Bool)
    case unfollowPlaylist(playlistID: String)
    case getMyFollowedArtists
    case follow(type: FollowType, ids: [String])
    case unfollow(type: FollowType, ids: [String])
    case checkIfIFollowArtistsOrUsers(type: FollowType, ids: [String])
    case checkIfIFollowPlaylist(playlistID: String)
}

@available(iOS 13.0, *)
extension UsersEndpoint: Endpoint {
    var baseURL: URL? {
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getMyProfile, .getUserProfile, .followPlaylist,
                .unfollowPlaylist, .checkIfIFollowPlaylist:
            return []
        case .getMyTopArtistsItems(config: let config), .getMyTopTracksItems(config: let config):
            let queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.timeRange.rawValue, value: config.timeRange.rawValue),
                .init(name: QueryItemKeys.limit.rawValue, value: "\(config.limit)"),
                .init(name: QueryItemKeys.offset.rawValue, value: "\(config.offset)"),
            ]
            return queryItems
        case .getMyFollowedArtists:
            let queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.type.rawValue, value: QueryItemKeys.artist.rawValue)
            ]
            return queryItems
        case .follow(let data), .unfollow(let data), .checkIfIFollowArtistsOrUsers(let data):
            let ids = data.ids.joined(separator: ",")
            let queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.type.rawValue, value: data.type.rawValue),
                .init(name: QueryItemKeys.ids.rawValue, value: ids)
            ]
            return queryItems
        }
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
            return "/v1/me"
        case .getMyTopArtistsItems(let config), .getMyTopTracksItems(let config):
            return "/v1/me/top/\(config.type.rawValue)"
        case .getUserProfile(let userID):
            return "/v1/users/\(userID)"
        case .followPlaylist(let playlistID, _), .unfollowPlaylist(let playlistID):
            return "/v1/playlists/\(playlistID)/followers"
        case .getMyFollowedArtists, .follow, .unfollow:
            return "/v1/me/following"
        case .checkIfIFollowArtistsOrUsers:
            return "/v1/me/following/contains"
        case .checkIfIFollowPlaylist(let playlistID):
            return "/v1/playlists/\(playlistID)/followers/contains"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .getMyProfile, .getMyTopArtistsItems, .getMyTopTracksItems,
                .getUserProfile, .getMyFollowedArtists, .checkIfIFollowArtistsOrUsers,
                .checkIfIFollowPlaylist:
            return .get
        case .followPlaylist, .follow:
            return .put
        case .unfollowPlaylist, .unfollow:
            return .delete
        }
    }
    
    var header: [String : String]? {
        let tokenType = KeychainService.shared.load(forKey: KeychainKeys.tokenType.str) as? String ?? ""
        let accessToken = KeychainService.shared.load(forKey: KeychainKeys.accessToken.str) as? String ?? ""
        switch self {
        case .getMyProfile, .getMyTopArtistsItems, .getMyTopTracksItems,
                .getUserProfile:
            let parameters: [String: String] = [
                "Content-Type": "application/x-www-form-urlencoded",
                QueryItemKeys.authorization.str: "\(tokenType) \(accessToken)"
            ]
            return parameters
        case .followPlaylist, .unfollow:
            let parameters: [String: String] = [
                "Content-Type": "application/json",
                QueryItemKeys.authorization.str: "\(tokenType) \(accessToken)",
            ]
            return parameters
        case .unfollowPlaylist, .getMyFollowedArtists, .follow,
                .checkIfIFollowArtistsOrUsers, .checkIfIFollowPlaylist:
            let parameters: [String: String] = [
                QueryItemKeys.authorization.str: "\(tokenType) \(accessToken)",
            ]
            return parameters
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getMyProfile, .getMyTopArtistsItems, .getMyTopTracksItems,
                .getUserProfile, .unfollowPlaylist, .getMyFollowedArtists,
                .checkIfIFollowArtistsOrUsers, .checkIfIFollowPlaylist:
            return nil
        case .followPlaylist(let makeItPublic):
            return [
                "public": makeItPublic.makeItPublic
            ]
        case .follow(let data), .unfollow(let data):
            return [
                "ids": data.ids
            ]
        }
    }
    
}
