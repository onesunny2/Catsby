//
//  ProfileNicknameView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

/*
 1. 커스텀 백버튼 (이전 뷰 컨트롤러 화면에서 설정해야 함)
 2. 프로필 이미지는 UIImageView으로 생성(tapGesture 예정)
    ㄴ 처음에 랜덤 이미지 들어가도록 enum 활용 예정
 3. 텍스트필드 - BaseView 만들까 했는데 화면 구성 상 한번만 들어갈 것 같아 단일 화면에서 구성
 4. underLine - UIView로 생성
 5. 닉네임 조건은 VC 단위에서 설정 예정 - 다만 처음엔 "" 공백
 */

final class ProfileNicknameView: BaseView {
    
    private let userdefaults = UserDefaultsManager.shared
    
    let profileImageView: BaseImageView
    let cameraImageView: BaseImageView
    let textfield = UITextField()
    private let underline = UIView()
    let checkNickname: BaseLabel
    let completeButton: BaseButton
    private let mbtiTitleLabel: BaseLabel
    let mbtiCollectionView: UICollectionView
    
    private func collectionviewFlowLayout() -> UICollectionViewFlowLayout {
        let cellSpacing: CGFloat = 12
        let cellWidth: CGFloat = (mbtiCollectionView.bounds.width - (cellSpacing * 3)) / 4
        let cellHeight: CGFloat = mbtiCollectionView.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = .zero
        
        return layout
    }
    
    
    override init(frame: CGRect) {
        let recentImage = userdefaults.getStringData(type: .profileImage)
        profileImageView = BaseImageView(type: UIImage(named: recentImage) ?? UIImage(), bgcolor: .catsBlack)
        
        let camera = UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(paletteColors: [.catsWhite, .catsMain]))
        cameraImageView = BaseImageView(type: camera ?? UIImage(), bgcolor: .clear)
        
        checkNickname = BaseLabel(text: " ", align: .left, color: .catsMain, size: 16, weight: .regular)
        
        completeButton = BaseButton(title: "완료", size: 16, weight: .bold, bgColor: .catsBlack, foreColor: .catsMain)
        completeButton.capsuleStyle()
        completeButton.stroke(.catsMain, 2)
        
        mbtiTitleLabel = BaseLabel(text: "MBTI", align: .left, size: 20, weight: .bold)
        
        mbtiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profileRadius = profileImageView.frame.width / 2
        profileImageView.clipCorner(profileRadius)
        profileImageView.stroke(.catsMain, 2)
        
        mbtiCollectionView.snp.makeConstraints {
            let cellHeight = ((mbtiCollectionView.bounds.width - 36) / 4) * 2 + 12
            $0.height.equalTo(cellHeight)
        }
        
        mbtiCollectionView.collectionViewLayout = collectionviewFlowLayout()
    }
    
    override func configHierarchy() {
        [profileImageView, cameraImageView, textfield, underline, checkNickname, mbtiTitleLabel, mbtiCollectionView, completeButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.size.equalTo(120)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(2)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(4)
            $0.size.equalTo(40)
            
        }
        
        textfield.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        underline.snp.makeConstraints {
            $0.top.equalTo(textfield.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(1)
        }
        
        checkNickname.snp.makeConstraints {
            $0.top.equalTo(underline.snp.bottom).offset(16)
            $0.leading.equalTo(textfield.snp.leading)
        }
        
        mbtiTitleLabel.snp.makeConstraints {
            $0.top.equalTo(checkNickname.snp.bottom).offset(35)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        
        mbtiCollectionView.snp.makeConstraints {
            $0.top.equalTo(mbtiTitleLabel.snp.top).offset(4)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.leading.equalTo(mbtiTitleLabel.snp.trailing).offset(60)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(25)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(44)
        }
    }
    
    private func configView() {
        textfield.textColor = .catsWhite
        textfield.attributedPlaceholder = NSAttributedString(string: "닉네임을 적어주세요 :>", attributes: [NSAttributedString.Key.foregroundColor: UIColor.catsDarkgray])
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.clearButtonMode = .whileEditing
        
        underline.backgroundColor = .catsWhite
        
        mbtiCollectionView.backgroundColor = .clear
        
        mbtiCollectionView.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.id)
    }
}
