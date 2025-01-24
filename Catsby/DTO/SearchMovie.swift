//
//  SearchMoview.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

struct SearchMovie: Decodable {
    let page: Int
    let results: [SearchResults]
    let totalPages: Int
    let totalResults: Int
    
    enum Codingkeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResults: Decodable {
    let id: Int
    let backdroppath: String
    let title: String
    let overview: String
    let posterpath: String
    let genreID: [Int]
    let releaseDate: String
    let vote: Double
    
    enum Codingkeys: String, CodingKey {
        case id
        case backdroppath = "backdrop_path"
        case title
        case overview
        case posterpath = "poster_path"
        case genreID = "genre_ids"
        case releaseDate = "release_date"
        case vote = "vote_average"
    }
}
