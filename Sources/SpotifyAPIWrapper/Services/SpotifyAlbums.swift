//
//  SpotifyAlbums.swift
//
//
//  Created by Bohdan Hawrylyshyn on 15.05.24.
//

import Foundation

@available(iOS 13.0.0, *)
final class SpotifyAlbums: HTTPClient {
    
    static let shared: SpotifyAlbums = .init()
    
    func getAlbum(id: String, market: String?) async -> Result<AlbumModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.getAlbum(id: id, market: market),
            responseModel: AlbumModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getSeveralAlbum(ids: [String], market: String?) async -> Result<SeveralAlbumsModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.getSeveralAlbums(ids: ids, market: market),
            responseModel: SeveralAlbumsModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getAlbumTracks(id: String, market: String?, limit: Int?, offset: Int?) async -> Result<AlbumTracksModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.getAlbumTracks(id: id, market: market, limit: limit, offset: offset),
            responseModel: AlbumTracksModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getMySavedAlbums(limit: Int?, offset: Int?, market: String?) async -> Result<MySavedAlbumsModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.getMySavedAlbums(limit: limit, offset: offset, market: market),
            responseModel: MySavedAlbumsModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func saveAlbumsForCurrentUser(ids: [String]) async {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.saveAlbumsForCurrentUser(ids: ids),
            responseModel: SaveAlbumsForCurrentUserModel.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func removeUsersSavedAlbums(ids: [String]) async {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.removeUsersSavedAlbums(ids: ids),
            responseModel: SaveAlbumsForCurrentUserModel.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func checkUsersSavedAlbums(ids: [String]) async -> Result<[Bool], HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.checkUsersSavedAlbums(ids: ids),
            responseModel: [Bool].self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getNewReleases(limit: Int?, offset: Int?) async -> Result<NewReleasesModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: AlbumsEndpoint.getNewReleases(limit: limit, offset: offset),
            responseModel: NewReleasesModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
}
