//
//  TopItemsConfig.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

public struct TopItemsConfig {
    let type: TopItemsType
    let timeRange: TopItemsTypeTimeRange
    let limit: Int
    let offset: Int
    
    public init(type: TopItemsType, timeRange: TopItemsTypeTimeRange, limit: Int, offset: Int) {
        self.type = type
        self.timeRange = timeRange
        self.limit = limit
        self.offset = offset
    }
}

public enum TopItemsType: String {
    case artists
    case tracks
}

public enum TopItemsTypeTimeRange: String {
    case long = "long_term"
    case medium = "medium_term"
    case short = "short_term"
}
