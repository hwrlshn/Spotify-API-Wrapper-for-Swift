//
//  AlbumsEndpoint.swift
//
//
//  Created by Bohdan Hawrylyshyn on 15.05.24.
//

import Foundation

enum AlbumsEndpoint {
    case getAlbum(id: String, market: String?)
    case getSeveralAlbums(ids: [String], market: String?)
    case getAlbumTracks(id: String, market: String?, limit: Int?, offset: Int?)
    case getMySavedAlbums(limit: Int?, offset: Int?, market: String?)
    case saveAlbumsForCurrentUser(ids: [String])
    case removeUsersSavedAlbums(ids: [String])
    case checkUsersSavedAlbums(ids: [String])
    case getNewReleases(limit: Int?, offset: Int?)
}

extension AlbumsEndpoint: Endpoint {
    
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
        case .saveAlbumsForCurrentUser, .removeUsersSavedAlbums:
            return []
        case .getAlbum(let data):
            if data.market != nil {
                return [
                    .init(name: QueryItemKeys.market.str, value: data.market ?? "")
                ]
            }
            return []
        case .getSeveralAlbums(let data):
            var queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.ids.str, value: data.ids.joined(separator: ","))
            ]
            if data.market != nil {
                queryItems.append(.init(name: QueryItemKeys.market.str, value: data.market ?? ""))
            }
            return queryItems
        case .getAlbumTracks(let data):
            var queryItems = [URLQueryItem]()
            if data.market != nil {
                queryItems.append(.init(name: QueryItemKeys.market.str, value: data.market ?? ""))
            }
            if data.limit != nil {
                queryItems.append(.init(name: QueryItemKeys.limit.str, value: "\(data.limit ?? 0)"))
            }
            if data.offset != nil {
                queryItems.append(.init(name: QueryItemKeys.offset.str, value: "\(data.offset ?? 0)"))
            }
            return queryItems
        case .getMySavedAlbums(let data):
            var queryItems = [URLQueryItem]()
            if data.limit != nil {
                queryItems.append(.init(name: QueryItemKeys.limit.str, value: "\(data.limit ?? 0)"))
            }
            if data.offset != nil {
                queryItems.append(.init(name: QueryItemKeys.offset.str, value: "\(data.offset ?? 0)"))
            }
            if data.market != nil {
                queryItems.append(.init(name: QueryItemKeys.market.str, value: data.market ?? ""))
            }
            return queryItems
        case .checkUsersSavedAlbums(let ids):
            let ids = ids.joined(separator: ",")
            let queryItems: [URLQueryItem] = [
                .init(name: QueryItemKeys.ids.rawValue, value: ids)
            ]
            return queryItems
        case .getNewReleases(let data):
            var queryItems = [URLQueryItem]()
            if data.limit != nil {
                queryItems.append(.init(name: QueryItemKeys.limit.str, value: "\(data.limit ?? 0)"))
            }
            if data.offset != nil {
                queryItems.append(.init(name: QueryItemKeys.offset.str, value: "\(data.offset ?? 0)"))
            }
            return queryItems
        }
    }
    
    var path: String {
        switch self {
        case .getAlbum(let data):
            return "/v1/albums/\(data.id)"
        case .getSeveralAlbums:
            return "/v1/albums"
        case .getAlbumTracks(let data):
            return "/v1/albums/\(data.id)/tracks"
        case .getMySavedAlbums, .saveAlbumsForCurrentUser, .removeUsersSavedAlbums:
            return "/v1/me/albums"
        case .checkUsersSavedAlbums(ids: let ids):
            return "/v1/me/albums/contains"
        case .getNewReleases(let data):
            return "/v1/browse/new-releases"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .getAlbum, .getSeveralAlbums, .getAlbumTracks,
                .getMySavedAlbums, .checkUsersSavedAlbums, .getNewReleases:
            return .get
        case .saveAlbumsForCurrentUser:
            return .put
        case .removeUsersSavedAlbums:
            return .delete
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getAlbum, .getSeveralAlbums, .getAlbumTracks,
                .getMySavedAlbums, .saveAlbumsForCurrentUser, .removeUsersSavedAlbums,
                .checkUsersSavedAlbums, .getNewReleases:
            let tokenType = KeychainService.shared.load(forKey: KeychainKeys.tokenType.str) as? String ?? ""
            let accessToken = KeychainService.shared.load(forKey: KeychainKeys.accessToken.str) as? String ?? ""
            let parameters: [String: String] = [
                QueryItemKeys.authorization.str: "\(tokenType) \(accessToken)",
            ]
            return parameters
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAlbum, .getSeveralAlbums, .getAlbumTracks,
                .getMySavedAlbums, .checkUsersSavedAlbums, .getNewReleases:
            return nil
        case .saveAlbumsForCurrentUser(let ids), .removeUsersSavedAlbums(let ids):
            return [
                "ids": ids
            ]
        }
    }
    
    
}
