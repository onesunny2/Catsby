//
//  TodayMovieView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import SnapKit

final class TodayMovieView: BaseView {
    
    private let profileboxView = ProfileBoxView()
    private let recentSearchLabel: BaseLabel
    private let recentSearchScrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let noSearchLabel: BaseLabel
    private let todayMovieLabel: BaseLabel
    let collectionView: UICollectionView
    
    private func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetPadding: CGFloat = 16
        let cellPadding: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width * 0.6
        let cellHeight: Double = UIScreen.main.bounds.height - (96 + profileboxView.frame.height + recentSearchScrollView.frame.height + recentSearchLabel.frame.height + todayMovieLabel.frame.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetPadding, bottom: 0, right: insetPadding)
        
        return layout
    }
    
    override init(frame: CGRect) {
        recentSearchLabel = BaseLabel(text: "최근검색어", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        let text = "최근 검색어 내역이 없습니다."
        noSearchLabel = BaseLabel(text: text, align: .center, color: .catsLightgray, size: 12, weight: .regular)
        
        todayMovieLabel = BaseLabel(text: "오늘의 영화", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(frame: frame)
        
        collectionView.collectionViewLayout = collectionViewFlowLayout()
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func configHierarchy() {
        [profileboxView, recentSearchLabel, recentSearchScrollView, todayMovieLabel, collectionView].forEach {
            self.addSubview($0)
        }
        recentSearchScrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(noSearchLabel)
    }
    
    override func configLayout() {
        profileboxView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(140)
        }
        
        recentSearchLabel.snp.makeConstraints {
            $0.top.equalTo(profileboxView.snp.bottom).offset(16)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        recentSearchScrollView.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(recentSearchScrollView)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(40)
        }
        
        noSearchLabel.snp.makeConstraints {
            $0.center.equalTo(scrollContentView)
        }
        
        todayMovieLabel.snp.makeConstraints {
            $0.top.equalTo(recentSearchScrollView.snp.bottom).offset(16)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self)
            $0.top.equalTo(todayMovieLabel.snp.bottom).offset(8)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configView() {
        [recentSearchScrollView, scrollContentView, collectionView].forEach {
            $0.backgroundColor = .clear
        }
        
        collectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
    }
}
