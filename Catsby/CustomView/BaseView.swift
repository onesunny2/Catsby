//
//  BaseView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/25/25.
//

import UIKit

class BaseView: UIView, BaseConfigure {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() { }
    
    func configLayout() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
