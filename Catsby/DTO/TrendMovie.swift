//
//  TrendMovie.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

struct TrendMovie: Decodable {
    let page: Int
    let results: [TrendResults]
}

struct TrendResults: Decodable {
    let backdrop: String
    let id: Int
    let title: String
    let overview: String
    let posterpath: String
    let genreID: [Int]
    let releaseDate: String
    let vote: Double
    
    enum CodingKeys: String, CodingKey {
        case backdrop = "backdrop_path"
        case id
        case title
        case overview
        case posterpath = "poster_path"
        case genreID = "genre_ids"
        case releaseDate = "release_date"
        case vote = "vote_average"
    }
}
