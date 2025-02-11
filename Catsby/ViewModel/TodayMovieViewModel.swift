//
//  TodayMovieViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import Foundation

/*
 < 메인 화면 중 오늘의 영화 부분만 담당 >
 ✅ 1. ViewDidLoad 시점에 오늘의 영화 데이터 전달받는다는 신호 전달(✓ Input)
 ✅ 2. 해당 신호를 통해 뷰모델에서 callRequest 호출
    -> 포스터이미지, 타이틀, 줄거리, 좋아요유무 내보내기 (✓ Output)
 ✅ 3. 하트 좋아요 로직 cell에서 VC에서 VM으로 옮기기 (✓ Input)
    -> 처리해야 할 작업
    1) userdefaults 매니저 내 changeDicData 실행 - VM에서 처리
    2) 메인화면 상단 프로필에 변경된 무비박스 카운트가 반영되도록 (✓ Output)
    3) 데이터 reload -> 이건 뷰컨에서 진행 (✓ Output)
 
 < 고려해야 할 부분 >
 - 이미지가 없을 때를 고려해 default 이미지 넣어두기
 */

final class TodayMovieViewModel: BaseViewModel {
    
    struct Input {
        let getTodayMovieData: Observable<Void> = Observable(())
        let heartBtnTapped: Observable<Int> = Observable(0)
    }
    
    struct Output {
        let trendMovieResults: Observable<[TrendResults]> = Observable([])
        let newMovieboxTitle: Observable<String> = Observable("")
        let reloadIndexPath: Observable<[IndexPath]> = Observable([])
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
        
        input.heartBtnTapped.lazyBind { [weak self] tag in
            self?.heartBtnTapped(tag)
        }
    }
}

// 실행 매서드 모음
extension TodayMovieViewModel {
    
    private func callRequest() {
        NetworkManager.shared.callRequest(type: TrendMovie.self, api: .trend) { [weak self] result in
           
            self?.output.trendMovieResults.value = result.results
            
        } failHandler: {
            // TODO: error 예외처리
            print("오류")
        }
    }
    
    private func heartBtnTapped(_ tag: Int) {
        
        // 해당 영화의 좋아요 적용 로직
        let movie = output.trendMovieResults.value[tag]
        UserDefaultsManager.shared.changeDicData(id: movie.id)
        
        // 버튼을 눌렀을 때 좋아요를 한 영화의 갯수
        let savedDicList = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let likedMovieCount = savedDicList.filter { $0.value == true }.count
        output.newMovieboxTitle.value = "\(likedMovieCount)개의 무비박스 보관중"
        
        // datareload 필요한 영화의 indexPath
        output.reloadIndexPath.value = [IndexPath(item: tag, section: 0)]
    }
}
