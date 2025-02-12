//
//  SearchResultViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/12/25.
//

import Foundation

/*
 < 현재 화면에 있는 기능 >
✅ 1. 화면 첫 시작 시 isEmptyFirst의 값에 따라 화면 첫 구성이 달라지는 부분 관리
 - true: 키보드 바로 올려주기, 빈화면
 - false: 최근검색어에 있던 키워드가 검색창에 입력되어있고, 해당 기반으로 검색결과 보여주기
 
 ✅ 2. API 로직 VM으로 옮기기
 - 이전화면에서 들어왔는지 vs 해당 화면에서 검색했는지에 따라 다르게 호출되도록 관리 (input이 다름)
 => 다시 생각해보니 키워드를 받았을 때로 해야할 것 같음
 
 ✅ 3. 검색로직
 - 엔터 눌렀을 때 userdefaults에 저장하되, 이미 이전에 한번 저장한 기록이 있다면 이전 기록 지우고 추가되도록 구현
 - 검색결과가 0이 아니면 스크롤 가장 상단으로 띄워주기
 
 ✅ 4. 테이블뷰 내부의 로직 분리
 - 1) 포스터 이미지 처리: 값이 없으면 기본 내장 로직으로 내보내기
 - 2) 가지고 있는 장르 갯수에 따라 보여주는 갯수 다르도록 분기처리
 - 3) 좋아요 눌렀을 때, 로직 VM으로 분리 (** 커스텀 버튼으로 교체하기)
        ㄴ 뒤로가기 눌렀을 때 이전 화면에 내용 전달해서 좋아요 바뀌었다고 알려줘야함! (프로필박스 및 오늘의 영화에 업데이트 필요)
 - 4) prefetching 기능 로직 VM으로 분리
 
 ✅ 5. 이전화면으로 돌아가는 backbutton 눌렀을 때, 최근 검색어 화면 잘 적용되도록 하기
 
 */

final class SearchResultViewModel: BaseViewModel {
    
    typealias CellData = (title: String, poster: String, date: String, genre: [String]?, isLiked: Bool)
    
    struct Input {
        let recentSearchKeyword: Observable<String> = Observable("")
        let cellData: Observable<SearchResults?> = Observable(nil)
        let clickedSearchBtn: Observable<String?> = Observable(nil)
        let tableIndexPaths: Observable<[IndexPath]> = Observable([])
        let heartBtnTapped: Observable<Int> = Observable(0)
    }
    
    struct Output {
        let searchResults: Observable<[SearchResults]> = Observable([])
        let isResultsZero: Observable<Bool> = Observable(true)
        let scrollToTop: Observable<Void> = Observable(())
        let reloadIndexPath: Observable<[IndexPath]> = Observable([])
        let sendHeartBtnAction: Observable<String> = Observable("")
        let reloadMainViewKeywords: Observable<[String]> = Observable([])
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    private let group = DispatchGroup()
    
    var isEmptyFirst: Bool = false
    private let defaultPoster = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYaqjTuNYAbIxAk0GzMiX8-ah3Q63B8cIBMyFJE1zx-4Ty8ZIOSAneIuNysLOXvIffm2o&usqp=CAU"
    private var isPageEnd: Bool = false
    private var currentPage: Int = 1
    private var currentKeyword: String = ""
    private(set) var cellData: CellData = ("", "", "", [], false)
    
    init() {
        print("검색결과 VM Init")
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    deinit {
        print("검색결과 VM Deinit")
    }
    
    func transformBinds() {
        input.recentSearchKeyword.lazyBind { [weak self] _ in
            guard let self else { return }
            currentKeyword = input.recentSearchKeyword.value
            callRequest(currentKeyword, currentPage)
        }
        
        input.clickedSearchBtn.lazyBind { [weak self] text in
            guard let self else { return }
            tappedSearchButton(text)
        }
        
        input.tableIndexPaths.bind { [weak self] indexPaths in
            self?.setPagenation(indexPaths)
        }
        
        input.heartBtnTapped.lazyBind { [weak self] tag in
            self?.tappedHeartButton(tag)
        }
        
        input.cellData.bind { [weak self] value in
            guard let value else {
                print("cellData value error")
                return
            }
            self?.cellData(value)
        }
    }
}

extension SearchResultViewModel {
    
    private func callRequest(_ keyword: String, _ page: Int) {
        
        group.enter()
        NetworkManager.shared.callRequest(type: SearchMovie.self, api: .search(keyword: keyword, page: page)) { [weak self] response in
            
            guard let self else { return }
            
            output.searchResults.value.append(contentsOf: response.results)
            
            let totalPage = (response.totalPages ?? 0) / 20
            if currentPage == totalPage {
                isPageEnd = true
            }
            
            group.leave()
            
        } failHandler: { [weak self] in
            guard let self else { return }
            print("request error")
            
            group.leave()
        }

        
        // 검색결과가 없으면 검색결과가 없다는 화면으로 변경하기 위한 로직
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            let isResultsAt = (output.searchResults.value.count == 0)
            output.isResultsZero.value = isResultsAt
        }
    }
    
    // CellForItemAt에서 가공되어야 할 데이터
    private func cellData(_ cell: SearchResults) {
        
        let title = cell.title
        
        var posterUrl = ""
        // 포스터 주소
        if let poster = cell.posterpath {
            posterUrl = NetworkManager.pathUrl + poster
        } else {
            posterUrl = defaultPoster
        }
        
        // 날짜 변환
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        let date = format.date(from: cell.releaseDate) ?? Date()
        let newDate = format.string(from: date)
        
        // 장르 처리
        let genreNum = cell.genreID
        let genre = genreNum.map { Genre.genreList[$0] ?? "" }
        
        // 좋아요 유무
        let key = String(cell.id)
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[key] ?? false

        cellData = (title, posterUrl, newDate, genre, isLiked)
    }
    
    // 서치바에서 검색버튼 눌렀을 때
    private func tappedSearchButton(_ keyword: String?) {
        
        guard let keyword else { return }
        
        var savedKeywords = UserDefaultsManager.shared.getArrayData(type: .recentKeyword)
        
        if let index = savedKeywords.firstIndex(of: keyword) {
            savedKeywords.remove(at: index)
        }
        savedKeywords.append(keyword)
        UserDefaultsManager.shared.saveData(value: savedKeywords, type: .recentKeyword)
        
        // 이전 검색결과에 대해 초기화 작업
        output.searchResults.value = []
        currentPage = 1
        currentKeyword = keyword
        
        callRequest(currentKeyword, 1)
        
        if output.searchResults.value.count != 0 {
            output.scrollToTop.value = ()
        }
        
        // 이전 메인화면의 최근 키워드 목록 업데이트
        output.reloadMainViewKeywords.value = savedKeywords.reversed()
    }
    
    // 페이지네이션을 위한 prefetch 처리
    private func setPagenation(_ indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if (output.searchResults.value.count - 5 == indexPath.item) && (isPageEnd == false) {
                currentPage += 1
                callRequest(currentKeyword , currentPage)
            }
        }
    }
    
    // 좋아요 버튼
    private func tappedHeartButton(_ tag: Int) {
        
        let movie = output.searchResults.value[tag]
        UserDefaultsManager.shared.changeDicData(id: movie.id)
        
        let savedLikedList = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let isLikedCount = savedLikedList.filter { $0.value == true }.count
        let newTitle = "\(isLikedCount)개의 무비박스 보관중"
        
       // 좋아요 갯수는 이전 화면과 연결해줄 때 적용(좋아요 갯수랑, 데이터 리로드 시키는 역할)
        output.sendHeartBtnAction.value = newTitle
        output.reloadIndexPath.value = [IndexPath(row: tag, section: 0)]
    }
}
