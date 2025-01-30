//
//  SettingTableViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell, BaseConfigure {
    
    static let id = "SettingTableViewCell"
    
    let titleLabel: BaseLabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel = BaseLabel(text: "", align: .left, size: 15, weight: .regular)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        self.addSubview(titleLabel)
    }
    
    func configLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    func getTitle(_ title: String) {
        titleLabel.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
