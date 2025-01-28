//
//  BaseButton.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class BaseButton: UIButton {
    
    init(
        title: String,
        size: CGFloat,
        weight: UIFont.Weight,
        bgColor: UIColor,
        foreColor: UIColor
    ) {
        super.init(frame: .zero)
        
        let container = AttributeContainer().font(.systemFont(ofSize: size, weight: weight))
        var config = UIButton.Configuration.filled()
        
        config.attributedTitle = AttributedString(title, attributes: container)
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = foreColor
        
        self.configuration = config
    }
    
    func changeTitle(title: String, size: CGFloat, weight: UIFont.Weight) {
        let container = AttributeContainer().font(.systemFont(ofSize: size, weight: weight))
        
        self.configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
    
    func buttonImage(image: UIImage) {
        self.configuration?.image = image
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
