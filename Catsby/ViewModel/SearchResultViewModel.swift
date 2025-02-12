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
 
 2. API 로직 VM으로 옮기기
 
 3. 검색로직
 - 엔터 눌렀을 때 userdefaults에 저장하되, 이미 이전에 한번 저장한 기록이 있다면 이전 기록 지우고 추가되도록 구현
 - 검색결과가 0이 아니면 스크롤 가장 상단으로 띄워주기
 
 4. 테이블뷰 내부의 로직 분리
 - 1) 포스터 이미지 처리: 값이 없으면 기본 내장 로직으로 내보내기
 - 2) 가지고 있는 장르 갯수에 따라 보여주는 갯수 다르도록 분기처리
 - 3) 좋아요 눌렀을 때, 로직 VM으로 분리 (** 커스텀 버튼으로 교체하기)
        ㄴ 뒤로가기 눌렀을 때 이전 화면에 내용 전달해서 좋아요 바뀌었다고 알려줘야함! (프로필박스 및 오늘의 영화에 업데이트 필요)ㅅ
 - 4) prefetching 기능 로직 VM으로 분리
 
 */

final class SearchResultViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    var isEmptyFirst: Bool = false
    
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
        
    }
}
