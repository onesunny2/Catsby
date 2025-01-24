//
//  ImageMovie.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

struct ImageMovie: Decodable {
    let backdrops: [ImageBackdrops]
    let id: Int
    let posters: [ImagePosters]
}

struct ImageBackdrops: Decodable {
    let filepath: String
    
    enum CodingKeys: String, CodingKey {
        case filepath = "file_path"
    }
}

struct ImagePosters: Decodable {
    let filepath: String
    
    enum CodingKeys: String, CodingKey {
        case filepath = "file_path"
    }
}

