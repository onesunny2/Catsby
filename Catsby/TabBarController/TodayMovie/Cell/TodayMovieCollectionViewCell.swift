//
//  TodayMovieCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit

final class TodayMovieCollectionViewCell: UICollectionViewCell {
    
    static let id = "TodayMovieCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .catsDarkgray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
