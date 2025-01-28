//
//  MovieDetailView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import SnapKit

final class MovieDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropCollectionView: UICollectionView
    private let backdropInfoLabel: BaseLabel
    private let synopsisTitleLabel: BaseLabel
    private let synopsisContentLabel: BaseLabel
    private let moreButton: BaseButton
    private let castTitleLabel: BaseLabel
    private let castCollectionView: UICollectionView
    private let posterTitleLabel: BaseLabel
    private let posterCollectionView: UICollectionView
    
    override init(frame: CGRect) {
        backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        backdropInfoLabel = BaseLabel(text: "Test | Test | Test", align: .center, color: .catsDarkgray, size: 12, weight: .regular)
        
        synopsisTitleLabel = BaseLabel(text: "Synopsis", align: .left, size: 16, weight: .semibold)
        
        synopsisContentLabel = BaseLabel(text: "Test\nTest\nTest\nTest\nTestnTestnTestnTestnTestnTestnTestnTestnTestnTestnTestnTest", align: .left, size: 14, weight: .regular, line: 3)
        
        moreButton = BaseButton(title: "More", size: 16, weight: .bold, bgColor: .clear, foreColor: .catsMain)
        
        castTitleLabel = BaseLabel(text: "Cast", align: .left, size: 16, weight: .semibold)
        
        castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        posterTitleLabel = BaseLabel(text: "Poster", align: .left, size: 16, weight: .semibold)
        
        posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backdropCollectionView.collectionViewLayout = backdropCollectionViewFlowLayout()
        castCollectionView.collectionViewLayout = castCollectionViewFlowLayout()
        posterCollectionView.collectionViewLayout = posterCollectionViewFlowLayout()
    }
    
    override func configHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backdropCollectionView, backdropInfoLabel, synopsisTitleLabel, synopsisContentLabel, moreButton, castTitleLabel, castCollectionView, posterTitleLabel, posterCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        backdropCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        backdropInfoLabel.snp.makeConstraints {
            $0.top.equalTo(backdropCollectionView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        synopsisTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backdropInfoLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(synopsisTitleLabel)
        }
        
        synopsisContentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(synopsisTitleLabel.snp.bottom).offset(16)
        }
        
        castTitleLabel.snp.makeConstraints {
            $0.top.equalTo(synopsisContentLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(castTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 6)
        }
        
        posterTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castCollectionView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(posterTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 5)
        }
    }
    
    private func configView() {
        
        scrollView.showsVerticalScrollIndicator = false
        
        [backdropCollectionView, castCollectionView, posterCollectionView].forEach {
            $0.backgroundColor = .catsMain
        }

        backdropCollectionView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.id)
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
    }
}

// MARK: collectionView layout
extension MovieDetailView {
    
    private func backdropCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let cellWidth = UIScreen.main.bounds.width
        let cellHeight = backdropCollectionView.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        return layout
    }
    
    private func castCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetSpacing: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.5
        let cellHeight: CGFloat = (castCollectionView.bounds.height - 16) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = insetSpacing
        layout.minimumInteritemSpacing = insetSpacing * 2
        layout.sectionInset = UIEdgeInsets(top: .zero, left: insetSpacing, bottom: .greatestFiniteMagnitude, right: insetSpacing)
        
        return layout
    }
    
    private func posterCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetSpacing: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 3.5
        let cellHeight: CGFloat = posterCollectionView.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = insetSpacing / 2
        layout.sectionInset = UIEdgeInsets(top: .zero, left: insetSpacing, bottom: .zero, right: insetSpacing)
        
        return layout
    }
    
}
