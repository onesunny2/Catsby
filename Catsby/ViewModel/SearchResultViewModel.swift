//
//  SearchResultViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/12/25.
//

import Foundation

final class SearchResultViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
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
