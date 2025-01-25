//
//  BaseButton.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class BaseButton: UIButton {
    
    init(image: UIImage, title: String, bgColor: UIColor, foreColor: UIColor) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        
        config.image = image
        config.title = title
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = foreColor
    }
    
    func cornerRadius(_ corner: CGFloat) {
        self.configuration?.cornerStyle = .fixed
        self.configuration?.background.cornerRadius = corner
    }
    
    func stroke(_ color: UIColor, _ width: CGFloat) {
        self.configuration?.background.strokeColor = color
        self.configuration?.background.strokeWidth = width
    }
    
    func capsuleStyle() {
        self.configuration?.cornerStyle = .capsule
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
