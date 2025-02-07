//
//  Observable.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/7/25.
//

import Foundation

final class Observable<T> {
    
    var closure: ((T) -> ())?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> ()) {
        closure(value)
        self.closure = closure
    }
    
    // 바로 didSet이 실행되지 않도록
    func lazyBind(_ closure: @escaping (T) -> ()) {
        self.closure = closure
    }
}
