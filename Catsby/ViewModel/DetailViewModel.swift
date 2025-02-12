//
//  DetailViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/13/25.
//

import Foundation

final class DetailViewModel: BaseViewModel {
    
    struct Input {
        
        
    }
    
    struct Output {
        
        
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        print("상세화면 VM Init")
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    deinit {
        print("상세화면 VM Deinit")
    }
    
    func transformBinds() {
        
    }
}
