//
//  TrendMovie.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

/*
 커스텀 디코딩 전략을 사용했을 때 얼마만큼의 예외처리를 해줄것인가? 다 해주는 것이 좋을까?
 */

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
