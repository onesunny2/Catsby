//
//  PosterCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterCollectionViewCell: UICollectionViewCell, BaseConfigure {

    static let id = "PosterCollectionViewCell"
    
    let posterImageView: BaseImageView
    
    override init(frame: CGRect) {
        posterImageView = BaseImageView(type: UIImage(), bgcolor: .clear)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        self.addSubview(posterImageView)
    }
    
    func configLayout() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func getPosterImage(url: String) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: posterImageView.frame.width, height: posterImageView.frame.height))
        
        posterImageView.kf.setImage(
            with: URL(string: url),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
