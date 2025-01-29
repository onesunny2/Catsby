//
//  NetworkManager.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import UIKit
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    static let pathUrl = "https://image.tmdb.org/t/p/w500"
    static let originalUrl = "https://image.tmdb.org/t/p/original"
    private init() {}

    func callRequest<T: Decodable>(type: T.Type, api: TmdbAPI, successHandler: @escaping (T) -> (), failHandler: @escaping () -> ()) {
        
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.queryParameter,
            encoding: URLEncoding(destination: .queryString),
            headers: api.header
        ).responseString { value in
//            dump(value)
        }
        
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.queryParameter,
            encoding: URLEncoding(destination: .queryString),
            headers: api.header
        ).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case let .success(result):
                successHandler(result)
            case let .failure(error):
                print(error)
                failHandler()
            }
        }
    }
}

extension NetworkManager {
    
    enum TmdbAPI {
        case trend
        case search(keyword: String)
        case image(movieID: Int)
        case credit(movieID: Int)
        
        var header: HTTPHeaders {
            guard let apiKey = Bundle.main.apiKey else { return HTTPHeaders() }
            return ["Authorization": "Bearer \(apiKey)"]
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var baseUrl: String {
            return "https://api.themoviedb.org/3/"
        }
        
        var endPoint: String {
            switch self {
            case .trend:
                return baseUrl + "trending/movie/day"
            case .search:
                return baseUrl + "search/movie"
            case let .image(id):
                return baseUrl + "movie/\(id)/images"
            case let .credit(id):
                return baseUrl + "movie/\(id)/credits"
            }
        }
        
        var queryParameter: Parameters {
            switch self {
            case .trend:
                return ["language": "ko-KR", "page": 1]
            case let .search(keyword):
                return ["query": keyword, "include_adult": "false", "language": "ko-KR", "page": 1]
            case .image:
                return [:]
            case .credit:
                return ["language": "ko-KR"]
            }
        }
    }
}
