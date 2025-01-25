//
//  BaseLabel.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

class BaseLabel: UILabel {
    
    init(text: String, align: NSTextAlignment, color: UIColor = .catsWhite, size: CGFloat, weight: UIFont.Weight, line: Int = 1) {
        super.init(frame: .zero)
        
        self.text = text
        self.textAlignment = align
        self.textColor = color
        self.font = .systemFont(ofSize: size, weight: weight)
        self.numberOfLines = line
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
