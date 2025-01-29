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
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5
        pageControl.currentPageIndicatorTintColor = .catsWhite
        pageControl.pageIndicatorTintColor = .catsDarkgray
        pageControl.backgroundStyle = .prominent
 
        return pageControl
    }()
    
    override init(frame: CGRect) {
        backdropImageView = BaseImageView(type: UIImage(), bgcolor: .clear)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
    }
    
    func configHierarchy() {
        self.addSubview(backdropImageView)
        self.addSubview(pageControl)
    }
    
    func configLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
