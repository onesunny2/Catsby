//
//  CastCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CastCollectionViewCell: UICollectionViewCell, BaseConfigure {
    
    static let id = "CastCollectionViewCell"
    
    let castImageView: BaseImageView
    let nameStackView = UIStackView()
    let castNameLabel: BaseLabel
    let roleNameLabel: BaseLabel
    
    override init(frame: CGRect) {
        castImageView = BaseImageView(type: UIImage(), bgcolor: .clear)
        
        castNameLabel = BaseLabel(text: "", align: .left, size: 14, weight: .bold)
        
        roleNameLabel = BaseLabel(text: "", align: .left, color: .catsDarkgray, size: 13, weight: .regular)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        [castImageView, nameStackView].forEach {
            self.addSubview($0)
        }
        [castNameLabel, roleNameLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    func configLayout() {
        let height: CGFloat = (UIScreen.main.bounds.height / 5.5 - 16) / 2
        
        castImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.size.equalTo(height)
        }
        
        nameStackView.snp.makeConstraints {
            $0.centerY.equalTo(castImageView)
            $0.leading.equalTo(castImageView.snp.trailing).offset(8)
        }
        
        nameStackView.axis = .vertical
        nameStackView.spacing = 10
        
        castNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        roleNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
    }
    
    func getDataFromAPI(_ url: String, _ castName: String, _ roleName: String) {
        castImageView.kf.setImage(with: URL(string: url),
                                  options: [
                                    .processor(DownSampling.processor(castImageView)),
                                    .scaleFactor(UIScreen.main.scale),
                                    .cacheOriginalImage
                                  ])
        
        castNameLabel.text = castName
        roleNameLabel.text = roleName
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
