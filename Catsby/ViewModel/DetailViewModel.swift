//
//  DetailViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/13/25.
//

import Foundation

/*
 < 전달 받아 해야하는 작업 >
 이전 화면에서 전달받은 데이터를 가지고
 ✅ 1. viewDidLoad에서 API 호출 신호를 보냄 (input)
 ✅ 2. 네트워크 통신을 통해 나온 모델을 가지고 가공해서 내보내기 (output)
 - 가공을 해서 내보내는 이유는 옵셔널 처리를 해야할 부분이 있을 것 같아서 후처리로 VC에서 사용하기 위함
 ** backdrop Image는 갯수에 맞춰서 해야함!! 5개 넘는지 미만인지에 따라서
 3. 좋아요 기능
 - 로직 userdefaults에 있는 것으로 변경
 - 상세화면에서 좋아요 누른 후 이전 화면에서 연동되어 보이도록
 
 */

final class DetailViewModel: BaseViewModel {
    
    typealias DetailData = (imgBackdrops: [ImageBackdrops], imgPosters: [ImagePosters], casts: [CreditCast])
    typealias BackDropDetail = (id: Int, title: String, synopsis: String, release: String, vote: Double, genre: [Int])
    
    struct Input {
        let callRequest: Observable<Void> = Observable(())
    }
    
    struct Output {
        let endCallRequest: Observable<Void> = Observable(())
        let detailData: Observable<DetailData> = Observable(([], [], []))
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    private let group = DispatchGroup()
    var backdropDetails: BackDropDetail = (0, "", "", "", 0.0, [])
    
    init() {
        print("상세화면 VM Init")
        
        input = Input()
        output = Output()
        
        print(genreList())
        
        transformBinds()
    }
    
    deinit {
        print("상세화면 VM Deinit")
    }
    
    func transformBinds() {
        input.callRequest.bind { [weak self] _ in
            guard let self else { return }
            callRequest(backdropDetails.id)
        }
    }
    
    func genreList() -> String {
        
        let list = Array(backdropDetails.genre.map { Genre.genreList[$0] ?? "" }.prefix(2))

        return list.joined(separator: ", ")
    }
}

extension DetailViewModel {
    
    private func callRequest(_ id: Int) {

        // backdrop, poster 정보
        group.enter()
        NetworkManager.shared.callRequest(type: ImageMovie.self, api: .image(movieID: id)) { [weak self] response in
            
            guard let self else { return }
            output.detailData.value.imgBackdrops = response.backdrops
            output.detailData.value.imgPosters = response.posters
            group.leave()
            
        } failHandler: { [weak self] in
            guard let self else { return }
            print("backdrop, poster error")
            group.leave()
        }

        // cast 정보
        group.enter()
        NetworkManager.shared.callRequest(type: CreditMovie.self, api: .credit(movieID: id)) { [weak self] response in
            
            guard let self else { return }
            output.detailData.value.casts = response.cast
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
