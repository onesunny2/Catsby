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
 ✅ 4. 포스터 url 값 내부에서 저장 프로퍼티로 계산해서 내보내기(좋아요 여부, pathurl) (observable ㄴㄴ)
 
 < 남은 로직 >
    1. 영화 상세화면 작업할 때, 좋아요 반영을 위해 남겨두었던 selectedMovie라던가 리터럴하게 선언된 부분 정리하기
 
 < 고려해야 할 부분 >
 - 이미지가 없을 때를 고려해 default 이미지 넣어두기 => 현재 전체적으로 VM 작업하고 난 후 건드려야할 것 같음. 안그러면 임시로 처음 값을 설정해둔 디코딩 모델들에 손이 많이 감
 */

final class TodayMovieViewModel: BaseViewModel {
    
    typealias IDAndPath = (Int, String)
    
    struct Input {
        let getTodayMovieData: Observable<Void> = Observable(())
        let heartBtnTapped: Observable<Int> = Observable(0)
        let cellIdAndPath: Observable<IDAndPath> = Observable((0, ""))
    }
    
    struct Output {
        let trendMovieResults: Observable<[SearchResults]> = Observable([])
        let newMovieboxTitle: Observable<String> = Observable("")
        let reloadIndexPath: Observable<[IndexPath]> = Observable([])
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    private(set) var isLiked = false
    private(set) var pathUrl = ""
    
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
        
        input.cellIdAndPath.bind { [weak self] id, url in
            self?.getBtnStatusAndPathurl(id, url)
        }
    }
    
    func movieboxCount() {
        let savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let count = savedDictionary.filter{ $0.value == true }.count
        let newtitle = "\(count)개의 무비박스 보관중"
        output.newMovieboxTitle.value = newtitle
    }
}

// 실행 매서드 모음
extension TodayMovieViewModel {
    
    private func callRequest() {
        NetworkManager.shared.callRequest(type: SearchMovie.self, api: .trend) { [weak self] result in
           
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
        movieboxCount()
        
        // datareload 필요한 영화의 indexPath
        output.reloadIndexPath.value = [IndexPath(item: tag, section: 0)]
    }
    
    private func getBtnStatusAndPathurl(_ id: Int, _ url: String) {
        
        let key = String(id)
        isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[key] ?? false
        
        pathUrl = NetworkManager.pathUrl + url
    }
}
