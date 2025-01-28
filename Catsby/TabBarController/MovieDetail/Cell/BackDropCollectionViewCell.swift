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
    
    let backdropImageView: BaseImageView
    let indicatorUIView = UIView()
    let indicatorStackView = UIStackView()
    let indicators: [UIView] = [UIView(), UIView(), UIView(), UIView(), UIView()]
    
    override init(frame: CGRect) {
        backdropImageView = BaseImageView(type: UIImage(), bgcolor: .clear)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configHierarchy() {
        self.addSubview(backdropImageView)
        self.addSubview(indicatorUIView)
        indicatorUIView.addSubview(indicatorStackView)
        indicators.forEach {
            indicatorStackView.addArrangedSubview($0)
        }
    }
    
    func configLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorUIView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
        
        indicatorStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(10)
        }
        
        indicatorStackView.axis = .horizontal
        indicatorStackView.distribution = .equalSpacing
        indicatorStackView.alignment = .center
        
        indicators.forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(8)
            }
        }
    }
    
    private func configView() {
        indicatorUIView.backgroundColor = .darkGray
        
        indicatorStackView.backgroundColor = .clear
        
        indicators.forEach {
            $0.backgroundColor = .catsDarkgray
        }
        indicators[0].backgroundColor = .catsLightgray
    }
    
    func corderRadius() {
        indicators.forEach {
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        indicatorUIView.layer.cornerRadius = 12
        indicatorUIView.clipsToBounds = true
        
        self.layoutIfNeeded()
    }
    
    func getBackdropImage(url: String) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: backdropImageView.frame.width, height: backdropImageView.frame.height))
        
        backdropImageView.kf.setImage(
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
