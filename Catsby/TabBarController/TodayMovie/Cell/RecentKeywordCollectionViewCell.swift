//
//  RecentKeywordCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/1/25.
//

import UIKit

final class RecentKeywordCollectionViewCell: UICollectionViewCell {
    
    static let id = "RecentKeywordCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .catsWhite
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
