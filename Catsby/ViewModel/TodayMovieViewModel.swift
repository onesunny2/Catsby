//
//  TodayMovieViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import Foundation

/*
 < 메인 화면 중 오늘의 영화 부분만 담당 >
 1. ViewDidLoad 시점에 오늘의 영화 데이터 전달받는다는 신호 전달(✓ Input)
 2. 해당 신호를 통해 뷰모델에서 callRequest 호출
    -> 포스터이미지, 타이틀, 줄거리, 좋아요유무 내보내기 (✓ Output)
 
 < 고려해야 할 부분 >
 - 이미지가 없을 때를 고려해 default 이미지 넣어두기
 */

final class TodayMovieViewModel: BaseViewModel {
    
    struct Input {
        let getTodayMovieData: Observable<Void> = Observable(())
    }
    
    struct Output {
        let trendMovieResults: Observable<[TrendResults]> = Observable([])
        
    }
    
    private(set) var input: Input
    private(set) var output: Output

    
    init() {
        print("오늘의영화 VM Init")
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    deinit {
        print("오늘의영화 VM Deinit")
    }
    
    func transformBinds() {
        input.getTodayMovieData.bind { [weak self] _ in
            self?.callRequest()
        }
    }
    
    private func callRequest() {
        NetworkManager.shared.callRequest(type: TrendMovie.self, api: .trend) { [weak self] result in
           
            self?.output.trendMovieResults.value = result.results
            
        } failHandler: {
            // TODO: error 예외처리
            print("오류")
        }
    }
}
