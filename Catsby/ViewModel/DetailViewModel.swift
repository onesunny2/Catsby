//
//  DetailViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/13/25.
//

import Foundation

final class DetailViewModel: BaseViewModel {
    
    struct Input {
        
        
    }
    
    struct Output {
        
        
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        print("상세화면 VM Init")
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    deinit {
        print("상세화면 VM Deinit")
    }
    
    func transformBinds() {
        input.callRequest.bind { [weak self] _ in
            self?.callRequest()
        }

    }
    
    func genreList() -> [String] {
        
        let list = backdropDetails.genre.map { Genre.genreList[$0] ?? "" }.filter { $0.count <= 2 }
        
        return list
    }
}

extension DetailViewModel {
    
    private func callRequest() {
        
        guard let movie else {
            print("movie data nill")
            return
        }
        
        // backdrop, poster 정보
        group.enter()
        NetworkManager.shared.callRequest(type: ImageMovie.self, api: .image(movieID: movie.id)) { [weak self] response in
            
            guard let self else { return }
            detailData.imgBackdrops = response.backdrops
            detailData.imgPosters = response.posters
            group.leave()
            
        } failHandler: { [weak self] in
            guard let self else { return }
            print("backdrop, poster error")
            group.leave()
        }

        // cast 정보
        group.enter()
        NetworkManager.shared.callRequest(type: CreditMovie.self, api: .credit(movieID: movie.id)) { [weak self] response in
            
            guard let self else { return }
            detailData.casts = response.cast
            group.leave()
            
        } failHandler: { [weak self] in
            guard let self else { return }
            print("cast error")
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            output.endCallRequest.value = ()
        }
    }
}
