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
    let titleLabel: BaseLabel
    let heartButton = UIButton()
    let plotLabel: BaseLabel
    
    override init(frame: CGRect) {
        posterImageView = BaseImageView(type: UIImage(named: "profile_11") ?? UIImage(), bgcolor: .catsWhite)
        
        titleLabel = BaseLabel(text: "", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        plotLabel = BaseLabel(text: "", align: .left, size: 12, weight: .regular, line: 2)
        
        super.init(frame: frame)

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
    
    func getData(url: String, title: String, plot: String) {
        posterImageView.kf.setImage(with: URL(string: url))
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
