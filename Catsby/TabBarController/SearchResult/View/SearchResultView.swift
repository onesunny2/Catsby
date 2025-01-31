//
//  SearchResultView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit
import SnapKit

final class SearchResultView: BaseView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func configHierarchy() {
        self.addSubview(tableView)
    }
    
    override func configLayout() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func configView() {
        tableView.backgroundColor = .clear
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
}
