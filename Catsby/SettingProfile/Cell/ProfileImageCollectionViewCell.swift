//
//  ProfileImageCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell, BaseConfigure {
    
    static let id = "ProfileImageCollectionViewCell"
    
    let profileImageView: BaseImageView
    
    override init(frame: CGRect) {
        profileImageView = BaseImageView(type: UIImage(), bgcolor: .catsBlack)
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        self.addSubview(profileImageView)
    }
    
    func configLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func clipImage() {
        let radius = self.bounds.width / 2
        profileImageView.clipCorner(radius)
        profileImageView.stroke(.catsLightgray, 1)
        self.layoutIfNeeded()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
