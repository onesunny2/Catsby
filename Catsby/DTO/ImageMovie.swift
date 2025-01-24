//
//  ImageMovie.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

struct ImageMovie: Decodable {
    let id: Int
    let backdrops: [ImageBackdrops]
    let posters: [ImagePosters]
}

struct ImageBackdrops: Decodable {
    let filepath: String
    
    enum Codingkeys: String, CodingKey {
        case filepath = "file_path"
    }
}

struct ImagePosters: Decodable {
    let filepath: String
    
    enum Codingkeys: String, CodingKey {
        case filepath = "file_path"
    }
}
