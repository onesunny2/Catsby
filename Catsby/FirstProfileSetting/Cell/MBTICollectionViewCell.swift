//
//  MBTICollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/9/25.
//

import UIKit

final class MBTICollectionViewCell: UICollectionViewCell {
    
    static let id = "MBTICollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .catsMain
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
