//
//  TodayMovieViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import Foundation

final class TodayMovieViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
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
        
    }
}
