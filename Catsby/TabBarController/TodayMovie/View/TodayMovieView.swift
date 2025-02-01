//
//  TodayMovieView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import SnapKit

final class TodayMovieView: BaseView {
    
    let profileboxView = ProfileBoxView()
    private let recentSearchLabel: BaseLabel
    private let recentKeywordContentView = UIView()
    let noSearchLabel: BaseLabel
    let recentKeywordCollectionView: UICollectionView
    private let todayMovieLabel: BaseLabel
    let todayMovieCollectionView: UICollectionView
    
    private func recentKaywordCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetPadding: CGFloat = 16
        let cellPadding: CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: insetPadding)
        
        return layout
    }
    
    private func todayMovieCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetPadding: CGFloat = 16
        let cellPadding: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width * 0.55
        let cellHeight: CGFloat = todayMovieCollectionView.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetPadding, bottom: 0, right: insetPadding)
        
        return layout
    }
    
    override init(frame: CGRect) {
        recentSearchLabel = BaseLabel(text: "최근검색어", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        recentKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        let text = "최근 검색어 내역이 없습니다."
        noSearchLabel = BaseLabel(text: text, align: .center, color: .catsDarkgray, size: 12, weight: .regular)
        
        todayMovieLabel = BaseLabel(text: "오늘의 영화", align: .left, color: .catsWhite, size: 16, weight: .bold)
        
        todayMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(frame: frame)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
        configView()
        
//        let count = UserDefaultsManager.shared.getArrayData(type: .recentKeyword).count
//        recentKeywordContentView.isHidden = (count == 0) ? false : true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recentKeywordCollectionView.collectionViewLayout = recentKaywordCollectionViewFlowLayout()
        todayMovieCollectionView.collectionViewLayout = todayMovieCollectionViewFlowLayout()
        
        recentKeywordCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    override func configHierarchy() {
        [profileboxView, recentSearchLabel, recentKeywordContentView, todayMovieLabel, todayMovieCollectionView].forEach {
            self.addSubview($0)
        }
        
        [recentKeywordCollectionView, noSearchLabel].forEach {
            recentKeywordContentView.addSubview($0)
        }
    }
    
    override func configLayout() {
        profileboxView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(140)
        }
        
        recentSearchLabel.snp.makeConstraints {
            $0.top.equalTo(profileboxView.snp.bottom).offset(16)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        recentKeywordContentView.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        noSearchLabel.snp.makeConstraints {
            $0.center.equalTo(recentKeywordContentView)
        }
        
        recentKeywordCollectionView.snp.makeConstraints {
            $0.edges.equalTo(recentKeywordContentView)
        }
        
        todayMovieLabel.snp.makeConstraints {
            $0.top.equalTo(recentKeywordContentView.snp.bottom).offset(16)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        todayMovieCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self)
            $0.top.equalTo(todayMovieLabel.snp.bottom).offset(8)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configView() {
        [recentKeywordContentView, recentKeywordCollectionView, todayMovieCollectionView].forEach {
            $0.backgroundColor = .clear
        }
    
        [recentKeywordCollectionView, todayMovieCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false
        }
        
        recentKeywordCollectionView.register(RecentKeywordCollectionViewCell.self, forCellWithReuseIdentifier: RecentKeywordCollectionViewCell.id)
        todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
    }
}
