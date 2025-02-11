//
//  RecentSearchKeywordViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import Foundation

final class RecentSearchKeywordViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
        
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    func transformBinds() {
        
    }
    
}
