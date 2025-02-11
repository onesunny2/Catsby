//
//  TodayMovieCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class TodayMovieCollectionViewCell: UICollectionViewCell, BaseConfigure {

    static let id = "TodayMovieCollectionViewCell"
    
    let posterImageView: BaseImageView
    let textStackView = UIStackView()
    let titleLabel: BaseLabel
    var heartButton: CustomHeartButton
    let plotLabel: BaseLabel
    
    var buttonTapAction: (() -> ())?
    
    override init(frame: CGRect) {
        posterImageView = BaseImageView(type: UIImage(named: "profile_11") ?? UIImage(), bgcolor: .catsWhite)
        
        titleLabel = BaseLabel(text: "", align: .left, color: .catsWhite, size: 16, weight: .bold)

        heartButton = CustomHeartButton()
        
        plotLabel = BaseLabel(text: "", align: .left, size: 12, weight: .regular, line: 2)
        
        super.init(frame: frame)

        configHierarchy()
        configLayout()
        configView()
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    
    @objc func heartButtonTapped() {
        buttonTapAction?()
    }
    
    func configHierarchy() {
        [posterImageView, textStackView, heartButton ].forEach {
            self.addSubview($0)
        }
        [titleLabel, plotLabel].forEach {
            textStackView.addArrangedSubview($0)
        }
    }
    
    func configLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.frame.height * 0.84)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        
        plotLabel.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(heartButton.snp.leading).offset(-8)
        }
        
        heartButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(16)
        }
    }
    
    private func configView() {
        posterImageView.backgroundColor = .catsDarkgray
    }
    
    func getData(url: String, title: String, plot: String) {
        posterImageView.kf.setImage(with: URL(string: url),
                                    options: [
                                        .processor(DownSampling.processor(posterImageView)),
                                        .scaleFactor(UIScreen.main.scale),
                                        .cacheOriginalImage
                                    ])
        
        titleLabel.text = title
        plotLabel.text = plot

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
