//
//  ProfileImageView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit
import SnapKit

/*
 1. 앞에서와 똑같은 프로필 이미지, 카메라 이미지 사용
 2. 12개의 이미지는 컬렉션뷰로 나열
 3. 데이터 전달은 앞에서 받은 것을 메인에, 여기서 선택한 것을 값 역전달 하도록
 */

final class ProfileImageView: BaseView {
    
    let mainImageView: BaseImageView
    let cameraImageView: BaseImageView
    let collectionView: UICollectionView
    
    private func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetPadding: CGFloat = 16
        let cellPadding: CGFloat = 10
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (insetPadding * 2 + cellPadding * 3)) / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetPadding, bottom: 0, right: insetPadding)
        
        return layout
    }
    
    override init(frame: CGRect) {
        let image = UIImage(named: "")
        mainImageView = BaseImageView(type: image ?? UIImage(), bgcolor: .catsBlack)
        
        let camera = UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(paletteColors: [.catsWhite, .catsMain]))
        cameraImageView = BaseImageView(type: camera ?? UIImage(), bgcolor: .clear)
        
        collectionView = UICollectionView(frame: .zero)
        
        super.init(frame: frame)
        
        collectionView.collectionViewLayout = collectionViewFlowLayout()
        backgroundColor = .catsBlack
        
        configHierarchy()
        configLayout()
        configureView()
    }
    
    override func configHierarchy() {
        [mainImageView, cameraImageView, collectionView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configLayout() {
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.size.equalTo(120)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.bottom.equalTo(mainImageView.snp.bottom).offset(2)
            $0.trailing.equalTo(mainImageView.snp.trailing).offset(4)
            $0.size.equalTo(40)
            
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.main.bounds.width * 0.75)
        }
    }
    
    private func configureView() {
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
}
