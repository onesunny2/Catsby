//
//  OnboardingView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    
    private var onboardingImageView = BaseImageView(type: UIImage(named: "onboarding") ?? UIImage(), bgcolor: .clear)
    private let titleLabel: BaseLabel
    private let detailLabel: BaseLabel
    let startButton: BaseButton
    
    override init(frame: CGRect) {
        titleLabel = BaseLabel(text: "Onboarding", align: .center, size: 36, weight: .bold)
        
        let detail = "당신만의 영화 세상,\nCatsby를 시작해보세요."
        detailLabel = BaseLabel(text: detail, align: .center, size: 16, weight: .regular, line: 2)
        
        startButton = BaseButton(title: "시작하기", size: 16, weight: .bold, bgColor: .catsBlack, foreColor: .catsMain)
        startButton.capsuleStyle()
        startButton.stroke(.catsMain, 2)
        
        super.init(frame: frame)
   
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
    }
    
    override func configHierarchy() {
        self.addSubview(onboardingImageView)
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(startButton)
    }
    
    override func configLayout() {
        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(UIScreen.main.bounds.width * 1.2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(onboardingImageView.snp.bottom)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(44)
        }
    }
}
