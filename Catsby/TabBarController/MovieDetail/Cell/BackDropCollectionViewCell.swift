//
//  BackDropCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class BackDropCollectionViewCell: UICollectionViewCell, BaseConfigure {
   
    static let id = "BackDropCollectionViewCell"
    
    private let backdropImageView: BaseImageView

    override init(frame: CGRect) {
        backdropImageView = BaseImageView(type: UIImage(), bgcolor: .clear)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        self.addSubview(backdropImageView)
    }
    
    func configLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func getBackdropImage(url: String) {
        backdropImageView.kf.setImage(
            with: URL(string: url),
            options: [
                .processor(DownSampling.processor(backdropImageView)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        
        backdropImageView.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
