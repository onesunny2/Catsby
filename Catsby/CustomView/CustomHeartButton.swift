//
//  CustomHeartButton.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/11/25.
//

import UIKit

final class CustomHeartButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.configuration = isSelected ? configButton(.like) : configButton(.unlike)
        }
    }
    
    init() {
        super.init(frame: .zero)
        isSelected = false
    }
    
    private func configButton(_ status: Status) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: status.imgName)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .catsMain
        
        return config
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        super.touchesEnded(touches, with: event)

        isSelected.toggle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomHeartButton {
    
    enum Status: String {
        case like = "heart.fill"
        case unlike = "heart"
        
        var imgName: String {
            return self.rawValue
        }
    }
}
