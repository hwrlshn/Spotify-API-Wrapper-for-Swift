//
//  HTTPRequestError.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

enum HTTPRequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case request(localizedDescription: String)
    case unauthorization
    case unexpectedStatus(code: Int)
    case `unknown`
}

extension HTTPRequestError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .decode:
            return "🛑 Decoding error"
        case .invalidURL:
            return "🛑 Invalid URL"
        case .noResponse:
            return "🛑 No response from server"
        case .request(localizedDescription: let localizedDescription):
            return "🛑 \(localizedDescription)"
        case .unauthorization:
            return "🛑 Unauthorization error"
        case .unexpectedStatus(code: let code):
            return "🛑 Unexpected HTTP status code: \(code)"
        case .unknown:
            return "🛑 Unknown error"
        }
    }
    
}
