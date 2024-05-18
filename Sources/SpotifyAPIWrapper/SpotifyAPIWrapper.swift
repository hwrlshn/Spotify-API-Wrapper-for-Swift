// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - Delegate funcs -

public protocol SpotifyAPIWrapperDelegate: AnyObject {
    func didAuthorized()
    func authorizationError()
}

// MARK: - API Wrapper Class -

@available(iOS 13.0, *)
public final class SpotifyAPIWrapper {
    
    // MARK: - Properties
    
    public static let shared: SpotifyAPIWrapper = .init()
    
    public weak var delegate: SpotifyAPIWrapperDelegate?
    
    private let authorizationService: SpotifyAuthorization = .shared
    private let usersService: SpotifyUsers = .shared
    private let albumsService: SpotifyAlbums = .shared
    
    // MARK: - Authorization funcs
    
    public func initWrapper(clientID: String, redirectUri: String) {
        guard KeychainService.shared.load(forKey: KeychainKeys.accessToken.str) != nil
        else {
            Task {
                await authorizationService.startAuthorization(
                    clientID: clientID,
                    redirectUri: redirectUri)
            }
            return
        }
        let currentDate = Date().timeIntervalSince1970
        let expiryDate = KeychainService.shared.load(forKey: KeychainKeys.expiresIn.str) as? Double ?? 0.0
        print("Token will live \(Int(expiryDate - currentDate)) seconds yet")
        guard currentDate < expiryDate
        else {
            print("Need refresh token")
            Task {
                let refreshToken = await authorizationService.refreshToken()
                switch refreshToken {
                case .success: delegate?.didAuthorized()
                case .failure: delegate?.authorizationError()
                }
            }
            return
        }
        print("Did authorized")
        delegate?.didAuthorized()
    }
    
    public func authorizationWithToken(code: String) {
        Task {
            let getAccessToken = await authorizationService.getAccessToken(code: code)
            switch getAccessToken {
            case .success: delegate?.didAuthorized()
            case .failure: delegate?.authorizationError()
            }
        }
    }
    
    // MARK: - Users funcs
    
    public func getMyProfile() async -> MyProfileModel? {
        return await fetchData { try await usersService.getMyProfile() }
    }
    
    public func getMyTopArtists(with config: TopItemsConfig) async -> TopItemsArtistsModel? {
        return await fetchData { try await usersService.getMyTopArtistsItems(with: config) }
    }
    
    public func getMyTopTracks(with config: TopItemsConfig) async -> TopItemsTracksModel? {
        return await fetchData { try await usersService.getMyTopTracksItems(with: config) }
    }
    
    public func getUserProfile(with userID: String) async -> UserProfileModel? {
        return await fetchData { try await usersService.getUserProfile(with: userID) }
    }
    
    public func followPlaylist(playlistID: String, makeItPublic: Bool) async {
        await usersService.followPlaylist(
            playlistID: playlistID,
            makeItPublic: makeItPublic)
    }
    
    public func unfollowPlaylist(playlistID: String) async {
        await usersService.unfollowPlaylist(playlistID: playlistID)
    }
    
    public func getMyFollowedArtists() async -> MyFollowedArtistsModel? {
        return await fetchData { try await usersService.getMyFollowedArtists() }
    }
    
    public func follow(type: FollowType, ids: [String]) async {
        await usersService.follow(type: type, ids: ids)
    }
    
    public func unfollow(type: FollowType, ids: [String]) async {
        await usersService.unfollow(type: type, ids: ids)
    }
    
    public func checkIfIFollowArtistsOrUsers(type: FollowType, ids: [String]) async -> [Bool]? {
        return await fetchData { try await usersService.checkIfIFollowArtistsOrUsers(type: type, ids: ids) }
    }
    
    public func checkIfIFollowPlaylist(playlistID: String) async -> [Bool]? {
        return await fetchData { try await usersService.checkIfIFollowPlaylist(playlistID: playlistID) }
    }
    
    // MARK: - Albums funcs
    
    public func getAlbum(id: String, market: String? = nil) async -> AlbumModel? {
        return await fetchData { try await albumsService.getAlbum(id: id, market: market) }
    }
    
    public func getSeveralAlbums(ids: [String], market: String? = nil) async -> SeveralAlbumsModel? {
        return await fetchData { try await albumsService.getSeveralAlbum(ids: ids, market: market) }
    }
    
    public func getAlbumTracks(id: String, market: String? = nil, limit: Int? = nil, offset: Int? = nil) async -> AlbumTracksModel? {
        return await fetchData { try await albumsService.getAlbumTracks(id: id, market: market, limit: limit, offset: offset) }
    }
    
    public func getMySavedAlbums(limit: Int? = nil, offset: Int? = nil, market: String? = nil) async -> MySavedAlbumsModel? {
        return await fetchData { try await albumsService.getMySavedAlbums(limit: limit, offset: offset, market: market) }
    }
    
    
    public func saveAlbumsForCurrentUser(ids: [String]) async {
        await albumsService.saveAlbumsForCurrentUser(ids: ids)
    }
    
    public func removeUsersSavedAlbums(ids: [String]) async {
        await albumsService.removeUsersSavedAlbums(ids: ids)
    }
    
    public func checkUsersSavedAlbums(ids: [String]) async -> [Bool]? {
        return await fetchData { try await albumsService.checkUsersSavedAlbums(ids: ids) }
    }
    
    public func getNewReleases(limit: Int? = nil, offset: Int? = nil) async -> NewReleasesModel? {
        return await fetchData { try await albumsService.getNewReleases(limit: limit, offset: offset) }
    }
    
}

// MARK: - Private extension -

@available(iOS 13.0, *)
private extension SpotifyAPIWrapper {
    
    func fetchData<T>(request: () async throws -> Result<T, HTTPRequestError>) async -> T? {
        do {
            let result = try await request()
            switch result {
            case .success(let data):
                return data
            case .failure:
                return nil
            }
        } catch {
            return nil
        }
    }
    
}
