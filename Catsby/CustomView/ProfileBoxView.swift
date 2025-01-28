//
//  ProfileBoxView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit
import SnapKit

final class ProfileBoxView: BaseView {
    
    private let backgroundView = UIView()
    let profileImageView: BaseImageView
    private let nicknameStackView = UIStackView()
    let nicknameLabel: BaseLabel
    private let registerDate: BaseLabel
    private let arrowImageView: BaseImageView
    var movieboxButton: BaseButton
    
    override init(frame: CGRect) {
        let profile = UserDefaultsManager.shared.getStringData(type: .profileImage)
        profileImageView = BaseImageView(type: UIImage(named: profile) ?? UIImage(), bgcolor: .clear)
        
        let nickname = UserDefaultsManager.shared.getStringData(type: .profileName)
        nicknameLabel = BaseLabel(text: nickname, align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        let date = UserDefaultsManager.shared.getDateData(type: .profileDate)
        registerDate = BaseLabel(text: date, align: .left, color: .catsLightgray, size: 12, weight: .regular)
        
        let arrow = UIImage(systemName: "chevron.right")?.withTintColor(.catsLightgray, renderingMode: .alwaysOriginal)
        arrowImageView = BaseImageView(type: arrow ?? UIImage(), bgcolor: .clear)
        
        let count = UserDefaultsManager.shared.getDicData(type: .likeButton).map { $0.value }.filter{ $0 == true }.count
        movieboxButton = BaseButton(title: "\(count)개의 무비박스 보관중", size: 14, weight: .bold, bgColor: .catsMain, foreColor: .catsWhite)
        
        super.init(frame: frame)
        
        movieboxButton.isUserInteractionEnabled = false
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = 30
        profileImageView.clipCorner(radius)
        profileImageView.stroke(.catsMain, 3)
        
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
    }
    
    override func configHierarchy() {
        self.addSubview(backgroundView)
        [profileImageView, nicknameStackView, arrowImageView, movieboxButton].forEach {
            backgroundView.addSubview($0)
        }
        [nicknameLabel, registerDate].forEach {
            nicknameStackView.addArrangedSubview($0)
        }
        
        nicknameStackView.axis = .vertical
        nicknameStackView.spacing = 2
        nicknameStackView.alignment = .leading
    }
    
    override func configLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(140)
        }

        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(60)
        }
        
        nicknameStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalTo(arrowImageView.snp.leading).inset(16)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalTo(backgroundView.snp.trailing).inset(16)
            $0.centerY.equalTo(profileImageView)
            $0.height.equalTo(profileImageView.frame.width / 3)
        }
        
        movieboxButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(backgroundView.snp.bottom).inset(16)
            $0.height.equalTo(35)
        }
        
    }
    
    private func configView() {
        backgroundView.backgroundColor = .darkGray  // TODO: 색상 바꾸기
    }
 
}
