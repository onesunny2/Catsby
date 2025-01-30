//
//  SearchResultTableViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {
    
    static let id = "SearchResultTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .catsBlack
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
