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
    let resultLabel: BaseLabel
    
    override init(frame: CGRect) {
        let text = "원하는 검색결과를 찾지 못했습니다"
        resultLabel = BaseLabel(text: text, align: .center, color: .catsDarkgray, size: 14, weight: .medium)
        
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        
        resultLabel.isHidden = true
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func configHierarchy() {
        self.addSubview(tableView)
        self.addSubview(resultLabel)
    }
    
    override func configLayout() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        resultLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    
    private func configView() {
        tableView.backgroundColor = .clear
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
}
