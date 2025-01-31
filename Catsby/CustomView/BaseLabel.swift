//
//  BaseLabel.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class BaseLabel: UILabel {
    
    init(
        text: String,
        align: NSTextAlignment,
        color: UIColor = .catsWhite,
        size: CGFloat,
        weight: UIFont.Weight,
        line: Int = 1
    ) {
        super.init(frame: .zero)
        
        self.text = text
        self.textAlignment = align
        self.textColor = color
        self.font = .systemFont(ofSize: size, weight: weight)
        self.numberOfLines = line
    }
    
    func badgeText(){
        
    }
    
    func imageWithText(_ image: String, _ text: String) {
        guard let symbolImage = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))?.withTintColor(.catsDarkgray, renderingMode: .alwaysOriginal) else { return }
        
        let attributeString = NSMutableAttributedString(string: "")
        let imageAttatchment = NSTextAttachment(image: symbolImage)
        imageAttatchment.bounds = .init(x: 0, y: -2, width: 14, height: 14)
        attributeString.append(NSAttributedString(attachment: imageAttatchment))
        attributeString.append(NSAttributedString(string: " " + text))
        
        self.attributedText = attributeString
        self.textAlignment = .center
        self.textColor = .catsDarkgray
        self.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
