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
    let backdropCollectionView: UICollectionView
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
    private let backdropInfoStackview = UIStackView()
    private let releaseDateLabel: BaseLabel
    private let dividerLabel1 = UIView()
    private let voteLabel: BaseLabel
    private let dividerLabel2 = UIView()
    private let genreLabel: BaseLabel
    private let synopsisTitleLabel: BaseLabel
    var synopsisContentLabel: BaseLabel
    var moreButton: BaseButton
    private let castTitleLabel: BaseLabel
    let castCollectionView: UICollectionView
    private let posterTitleLabel: BaseLabel
    let posterCollectionView: UICollectionView
    
    override init(frame: CGRect) {
        backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        releaseDateLabel = BaseLabel(text: "", align: .center, size: 14, weight: .regular)
        voteLabel = BaseLabel(text: "", align: .center, size: 14, weight: .regular)
        genreLabel = BaseLabel(text: "", align: .center, size: 14, weight: .regular)
        
        synopsisTitleLabel = BaseLabel(text: "Synopsis", align: .left, size: 16, weight: .semibold)
        
        synopsisContentLabel = BaseLabel(text: "", align: .left, size: 14, weight: .regular, line: 3)
        
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
        [backdropCollectionView, pageControl, backdropInfoStackview, synopsisTitleLabel, synopsisContentLabel, moreButton, castTitleLabel, castCollectionView, posterTitleLabel, posterCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        [releaseDateLabel, dividerLabel1, voteLabel, dividerLabel2, genreLabel].forEach {
            backdropInfoStackview.addArrangedSubview($0)
        }
    }
    
    override func configLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(self.snp.height)
        }
        
        backdropCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(cellHeight.backdrop.height)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backdropCollectionView.snp.bottom).inset(12)
        }
        
        backdropInfoStackview.snp.makeConstraints {
            $0.top.equalTo(backdropCollectionView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        backdropInfoStackview.axis = .horizontal
        backdropInfoStackview.spacing = 12
        backdropInfoStackview.alignment = .center
        
        [dividerLabel1, dividerLabel2].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(1.5)
                $0.height.equalTo(18)
            }
        }
        
        synopsisTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backdropInfoStackview.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(synopsisTitleLabel)
        }
        
        synopsisContentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(synopsisTitleLabel.snp.bottom).offset(16)
            $0.height.greaterThanOrEqualTo(35)
        }
        
        castTitleLabel.snp.makeConstraints {
            $0.top.equalTo(synopsisContentLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(castTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(cellHeight.cast.height)
        }
        
        posterTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castCollectionView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(posterTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(cellHeight.poster.height)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configView() {
        
        scrollView.showsVerticalScrollIndicator = false
        
        dividerLabel1.backgroundColor = .catsDarkgray
        dividerLabel2.backgroundColor = .catsDarkgray
        
        [backdropCollectionView, castCollectionView, posterCollectionView].forEach {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
        
        backdropCollectionView.isPagingEnabled = true

        backdropCollectionView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.id)
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
    }
    
    func setBackdropInfo(_ release: String, _ vote: String, _ genre: String) {
        releaseDateLabel.imageWithText("calendar", release)
        voteLabel.imageWithText("star.fill", vote)
        genreLabel.imageWithText("film.fill", genre)
    }
}

// MARK: collectionView layout
extension MovieDetailView {
    
    private func backdropCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let cellWidth = UIScreen.main.bounds.width
        let cellHeight = cellHeight.backdrop.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    private func castCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetSpacing: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.5
        let cellHeight: CGFloat = (cellHeight.cast.height - 16) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = insetSpacing * 2
        layout.minimumInteritemSpacing = insetSpacing
        layout.sectionInset = UIEdgeInsets(top: .zero, left: insetSpacing, bottom: .zero, right: insetSpacing)
        
        return layout
    }
    
    private func posterCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let insetSpacing: CGFloat = 16
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 3
        let cellHeight: CGFloat = cellHeight.poster.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = insetSpacing / 2
        layout.sectionInset = UIEdgeInsets(top: .zero, left: insetSpacing, bottom: .zero, right: insetSpacing)
        
        return layout
    }
}

extension MovieDetailView {
    enum cellHeight {
        case backdrop
        case cast
        case poster
        
        var height: CGFloat {
            switch self {
            case .backdrop:
                return UIScreen.main.bounds.height / 3.5
            case .cast:
                return UIScreen.main.bounds.height / 5.5
            case .poster:
                return UIScreen.main.bounds.height / 4.5
            }
        }
    }
}
