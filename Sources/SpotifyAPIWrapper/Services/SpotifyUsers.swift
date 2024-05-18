//
//  SpotifyUsers.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

@available(iOS 13.0, *)
internal final class SpotifyUsers: HTTPClient {
    
    internal static let shared: SpotifyUsers = .init()
    
    private init() { }
    
    // MARK: - My Profile
    
    func getMyProfile() async -> Result<MyProfileModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.getMyProfile,
            responseModel: MyProfileModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    // MARK: - My Top Items
    
    func getMyTopArtistsItems(with config: TopItemsConfig) async -> Result<TopItemsArtistsModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.getMyTopArtistsItems(config: config),
            responseModel: TopItemsArtistsModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getMyTopTracksItems(with config: TopItemsConfig) async -> Result<TopItemsTracksModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.getMyTopTracksItems(config: config),
            responseModel: TopItemsTracksModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getUserProfile(with userID: String) async -> Result<UserProfileModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.getUserProfile(userID: userID),
            responseModel: UserProfileModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func followPlaylist(playlistID: String, makeItPublic: Bool) async {
        let result = await sendRequest(
            endpoint: UsersEndpoint.followPlaylist(
                playlistID: playlistID,
                makeItPublic: makeItPublic),
            responseModel: FollowPlaylistModel.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func unfollowPlaylist(playlistID: String) async {
        let result = await sendRequest(
            endpoint: UsersEndpoint.unfollowPlaylist(playlistID: playlistID),
            responseModel: String.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func getMyFollowedArtists() async -> Result<MyFollowedArtistsModel, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.getMyFollowedArtists,
            responseModel: MyFollowedArtistsModel.self)
        switch result {
        case .success(let success):
            print(success)
            return .success(success)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func follow(type: FollowType, ids: [String]) async {
        let result = await sendRequest(
            endpoint: UsersEndpoint.follow(type: type, ids: ids),
            responseModel: FollowModel.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func unfollow(type: FollowType, ids: [String]) async {
        let result = await sendRequest(
            endpoint: UsersEndpoint.unfollow(type: type, ids: ids),
            responseModel: FollowModel.self)
        switch result {
        case .success, .failure:
            break
        }
    }
    
    func checkIfIFollowArtistsOrUsers(type: FollowType, ids: [String]) async -> Result<[Bool], HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.checkIfIFollowArtistsOrUsers(type: type, ids: ids),
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
    
    func checkIfIFollowPlaylist(playlistID: String) async -> Result<[Bool], HTTPRequestError> {
        let result = await sendRequest(
            endpoint: UsersEndpoint.checkIfIFollowPlaylist(playlistID: playlistID),
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
}
