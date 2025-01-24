//
//  CreditMovie.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

struct CreditMovie: Decodable {
    let id: Int
    let cast: [CreditCast]
}

struct CreditCast: Decodable {
    let name: String
    let character: String
    let profilepath: String
    
    enum Codingkeys: String, CodingKey {
        case name
        case character
        case profilepath = "profile_path"
    }
}
