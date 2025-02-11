//
//  CustomHeartButton.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import UIKit

final class CustomHeartButton: UIButton {
    
    init(movieID: Int) {
        super.init(frame: .zero)
        
        let stringID = String(movieID)
        let isLiked: Bool = UserDefaultsManager.shared.getDicData(type: .likeButton)[stringID] ?? false
        
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .catsMain
        
        self.configuration = config
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
