//
//  HTTPClient.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import UIKit

@available(iOS 13.0.0, *)
protocol HTTPClient {
    func sendRequest<T: Decodable>(
        session: URLSession,
        endpoint: Endpoint,
        responseModel: T.Type) async -> Result<T, HTTPRequestError>
}

@available(iOS 13.0.0, *)
extension HTTPClient {
    func sendRequest<T: Decodable>(session: URLSession = .shared,
                                   endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, HTTPRequestError> {
        guard let url = endpoint.baseURL
        else { return .failure(.invalidURL) }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        switch responseModel {
        case is FollowPlaylistModel.Type:
            if let body = endpoint.body as? [String: Bool] {
                request.httpBody = try? JSONEncoder().encode(body)
            }
        case is SaveAlbumsForCurrentUserModel.Type:
            if let body = endpoint.body as? [String: [String]] {
                request.httpBody = try? JSONEncoder().encode(body)
            }
        case is FollowModel.Type:
            if let body = endpoint.body as? [String: [String]] {
                let bodyString = body.map { "\($0)=\($1)" }.joined(separator: "&")
                request.httpBody = bodyString.data(using: .utf8)
            }
        default:
            if let body = endpoint.body {
                let bodyString = body.map { "\($0)=\($1)" }.joined(separator: "&")
                request.httpBody = bodyString.data(using: .utf8)
            }
        }
        
#if DEBUG
        request.debug()
#endif
        
        switch responseModel {
        case is RequestCodeModel.Type:
            if let authUrl = request.url {
                await UIApplication.shared.open(
                    authUrl,
                    options: [:],
                    completionHandler: nil)
            }
            return .failure(.noResponse)
        default:
            return await withCheckedContinuation({ continuation in
                session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        return continuation.resume(
                            returning: .failure(
                                .request(
                                    localizedDescription: error.localizedDescription)))
                    }
                    guard let responseCode = (response as? HTTPURLResponse)?.statusCode
                    else { return continuation.resume(returning: .failure(.noResponse)) }
                    
                    switch responseCode {
                    case 200...209:
                        guard let data = data,
                              let decodeResponse = try? JSONDecoder().decode(responseModel, from: data)
                        else { return continuation.resume(returning: .failure(.decode)) }
                        return continuation.resume(returning: .success(decodeResponse))
                    case 401:
                        return continuation.resume(returning: .failure(.unauthorization))
                    default:
                        return continuation.resume(returning: .failure(.unexpectedStatus(code: responseCode)))
                    }
                }.resume()
            })
        }
    }
}

private extension URLRequest {
    
    func debug() {
        print(">>>>>> START URL REQUEST >>>>>>")
        print("🌐 URL:", self.url ?? "❌")
        print("🌐 Method:", self.httpMethod ?? "❌")
        print("🌐 Headers:", self.allHTTPHeaderFields ?? "❌")
        print("🌐 Body:", String(data: self.httpBody ?? Data(), encoding: .utf8) ?? "❌")
        print(">>>>>> END URL REQUEST >>>>>>")
    }
    
}
