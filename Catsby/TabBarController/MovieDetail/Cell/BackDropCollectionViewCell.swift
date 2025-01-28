//
//  BackDropCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit

final class BackDropCollectionViewCell: UICollectionViewCell {
    
    static let id = "BackDropCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
