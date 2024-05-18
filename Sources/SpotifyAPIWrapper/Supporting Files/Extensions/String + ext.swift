//
//  String + ext.swift
//
//
//  Created by Bohdan Hawrylyshyn on 12.05.24.
//

import Foundation

extension String {
    
    static func generateRandomString(with length: Int) -> String {
        let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var string = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(possible.count)))
            string += String(possible[possible.index(possible.startIndex, offsetBy: randomIndex)])
        }
        return string
    }
    
}
