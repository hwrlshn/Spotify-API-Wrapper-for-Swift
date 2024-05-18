//
//  Endpoint.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var queryItems: [URLQueryItem] { get }
    var path: String { get }
    var method: HTTPRequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}
