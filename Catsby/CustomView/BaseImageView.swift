//
//  BaseImageView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class BaseImageView: UIImageView {
    
    init(type: UIImage, bgcolor: UIColor) {
        super.init(frame: .zero)
        
        self.image = type
        self.contentMode = .scaleAspectFill
        self.backgroundColor = bgcolor
    }
    
    func clipCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func stroke(_ color: UIColor, _ width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
