//
//  RecentSearchKeywordViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import Foundation

/*
 < 분리되어야 할 로직 >
 ✅ 1. 화면 분기점: viewdidLoad에서 트리거 받아서(✓ Input) bool값 내보내기(✓ output)
    📌 기존에는 viewIsAppearing을 통해서 검색결과 내용을 반영시켰는데, 추후 검색결과 화면 VM 로직 짜면서 분리해줄 방법 찾기 (현재는 viewDidLoad에만... 매번 부르면 코스트가 많이 들 것 같음)
 2. 저장된 키워드 리스트를 시간순으로 보여주기 위해 역순으로 처리해서 내보내기(✓ output)
    - output값 바인딩되면 datareload
 3. 전체 삭제 버튼 @objc 함수에서 트리거하기(✓ Input)
    - 알럿 메시지의 action값을 input으로 해서... 처리해야하나..?
 4. 현재 cell 안에 있는 삭제 로직 VC으로 꺼내서 VM에서 처리(✓ Input) & (✓ output)
 */

final class RecentSearchKeywordViewModel: BaseViewModel {
    
    struct Input {
        let checkKeyword: Observable<Void> = Observable(())
        let alertAction: Observable<Void> = Observable(())
        let requestKeywordsList: Observable<Void> = Observable(())
    }
    
    struct Output {
        let isKeywordIn: Observable<Bool> = Observable(false)
        let reversedKeywordsList: Observable<[String]> = Observable([])
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    func transformBinds() {
        
        input.checkKeyword.bind { [weak self] _ in
            self?.checkKeyword()
        }
        
        input.alertAction.lazyBind { [weak self] _ in
            self?.removeAllKeywords()
        }
        
        input.requestKeywordsList.bind { [weak self] _ in
            self?.getUserdefaultsKeywords()
        }
    }
    
}

// 매서드 분리
extension RecentSearchKeywordViewModel {
    
    // 맨 처음 화면 진입 시, 최근검색어 갯수에 따라 화면 분기점 분리
    private func checkKeyword() {
        
        let searchKeywordList = UserDefaultsManager.shared.getArrayData(type: .recentKeyword)
        let keywordCount = searchKeywordList.count
        output.isKeywordIn.value = (keywordCount == 0)
    }
    
    // 저장된 리스트 불러내서 collectionview CellForItemAt에 뿌리기
    private func getUserdefaultsKeywords() {
        
        let reversedList = UserDefaultsManager.shared.getArrayData(type: .recentKeyword).reversed()
        output.reversedKeywordsList.value = Array(reversedList)
    }
    
    // 기존에 저장된 키워드 리스트 싹 삭제
    private func removeAllKeywords() {
        
        UserDefaultsManager.shared.resetOneData(type: .recentKeyword)
        
        // 화면에 배열 불러내서 거기에 빈 것 넣어야할 것 같음
       
    }
}
