//
//  TodayMovieCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import SnapKit

final class TodayMovieCollectionViewCell: UICollectionViewCell, BaseConfigure {

    static let id = "TodayMovieCollectionViewCell"
    
    let posterImageView: BaseImageView
    let titleLabel: BaseLabel
    let heartButton = UIButton()
    let plotLabel: BaseLabel
    
    override init(frame: CGRect) {
        posterImageView = BaseImageView(type: UIImage(named: "profile_11") ?? UIImage(), bgcolor: .catsWhite)
        
        titleLabel = BaseLabel(text: "짜리몽땅 이짜몽", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
//        heartButton = BaseButton(title: "", size: 0, weight: .bold, bgColor: .clear, foreColor: .catsMain)
        
        let plot = "안녕하세요 저는 리캡과제 중 입니다. 지금은 12시가 넘어서 월요일이구요 과제 제출은 토요일인데요 지금 저는 20%는 끝냈을까요? 저는 이제 어떻게 하나요 살려주세요ㅠㅠㅠㅠㅠㅠㅠㅠ"
        plotLabel = BaseLabel(text: plot, align: .left, size: 12, weight: .regular, line: 2)
        
        super.init(frame: frame)
        
//        heartButton.buttonImage(image: UIImage(systemName: "heart") ?? UIImage())
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configHierarchy() {
        [posterImageView, plotLabel, titleLabel, heartButton ].forEach {
            self.addSubview($0)
        }
 
    }
    
    func configLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.frame.height * 0.84)
        }
        
        plotLabel.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(plotLabel.snp.top).offset(-4)
        }
        
        heartButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(16)
        }
    }
    
    private func configView() {
        posterImageView.backgroundColor = .catsDarkgray
        
        heartButton.configuration = .filled()
        heartButton.configuration?.image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16)))
        heartButton.configuration?.imagePadding = 0
        heartButton.configuration?.baseForegroundColor = .catsMain
        heartButton.configuration?.baseBackgroundColor = .clear
    }
    
    func posterCornerRadius() {
        posterImageView.clipCorner(10)
        
        self.layoutIfNeeded()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
