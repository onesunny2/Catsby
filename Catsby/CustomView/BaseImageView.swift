//
//  BaseImageView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class BaseImageView: UIImageView {
    
    init(type: UIImage) {
        super.init(frame: .zero)
        
        self.image = type
        self.contentMode = .scaleAspectFill
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
