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
    ㄴ 처음에 랜덤 이미지 들어가도록 enum caseIterable 활용 예정
 3. 텍스트필드 - BaseView 만들까 했는데 화면 구성 상 한번만 들어갈 것 같아 단일 화면에서 구성
 4. underLine - UIView로 생성
 5. 닉네임 조건은 VC 단위에서 설정 예정 - 다만 처음엔 "" 공백
 */

final class ProfileNicknameView: BaseView {
    
    let profileImageView: BaseImageView
    let cameraImageView: BaseImageView
    let textfield = UITextField()
    let underline = UIView()
    let checkNickname: BaseLabel
    let completeButton: BaseButton
    
    
    override init(frame: CGRect) {
        let image = UIImage(named: "profile_11")
        profileImageView = BaseImageView(type: image ?? UIImage(), bgcolor: .catsBlack)
        
        let camera = UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(paletteColors: [.catsWhite, .catsMain]))
        cameraImageView = BaseImageView(type: camera ?? UIImage(), bgcolor: .clear)
        
        checkNickname = BaseLabel(text: "Test", align: .left, color: .catsMain, size: 16, weight: .regular)
        
        completeButton = BaseButton(title: "완료", size: 18, weight: .bold, bgColor: .catsBlack, foreColor: .catsMain)
        completeButton.capsuleStyle()
        completeButton.stroke(.catsMain, 1)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profileRadius = profileImageView.frame.width / 2
        profileImageView.clipCorner(profileRadius)
        profileImageView.stroke(.catsMain, 2)
    }
    
    override func configHierarchy() {
        [profileImageView, cameraImageView, textfield, underline, checkNickname, completeButton].forEach {
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
            $0.top.equalTo(textfield.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(1)
        }
        
        checkNickname.snp.makeConstraints {
            $0.top.equalTo(underline.snp.bottom).offset(16)
            $0.leading.equalTo(textfield.snp.leading)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(checkNickname.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(44)
        }
    }
    
    func configView() {
        textfield.attributedPlaceholder = NSAttributedString(string: "닉네임을 적어주세요 :>", attributes: [NSAttributedString.Key.foregroundColor: UIColor.catsDarkgray])
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.clearButtonMode = .whileEditing
        
        underline.backgroundColor = .catsWhite
    }
}
