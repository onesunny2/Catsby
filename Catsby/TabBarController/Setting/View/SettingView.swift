//
//  SettingView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    let profileboxView = ProfileBoxView()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func configHierarchy() {
        self.addSubview(profileboxView)
        self.addSubview(tableView)
    }
    
    override func configLayout() {
        profileboxView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(140)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileboxView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(250)
        }
    }
    
    func configView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .catsDarkgray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
    }
}
