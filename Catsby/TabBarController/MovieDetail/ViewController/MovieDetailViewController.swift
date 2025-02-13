//
//  MovieDetailViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {
    
    private let mainView = MovieDetailView()
    let viewModel = DetailViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setNavigation()
        setDataFromAPI()
        bindVMData()
        
        viewModel.input.callRequest.value = ()
        
        mainView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    deinit {
        print("상세화면 VC Deinit")
    }
    
    private func bindVMData() {
        viewModel.output.endCallRequest.bind { [weak self] _ in
            guard let self else { return }
            mainView.backdropCollectionView.reloadData()
            mainView.castCollectionView.reloadData()
            mainView.posterCollectionView.reloadData()
            
            // 자꾸 처음에 위치가 튀는 것 때문에 설정
            setCollectionViewScrollOffset()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.castCollectionView.contentOffset.x = -mainView.castCollectionView.contentInset.left
    }
    
    @objc func moreButtonTapped(_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case "More":
            mainView.moreButton.changeTitle(title: "Hide", size: 16, weight: .bold)
            mainView.synopsisContentLabel.numberOfLines = 0

        case "Hide":
            mainView.moreButton.changeTitle(title: "More", size: 16, weight: .bold)
            mainView.synopsisContentLabel.numberOfLines = 3
  
        default:
            print(#function, "error")
        }
    }
    
    private func setCollectionViewScrollOffset() {
        mainView.castCollectionView.contentOffset.x = -mainView.castCollectionView.contentInset.left
        mainView.posterCollectionView.contentOffset.x = -mainView.posterCollectionView.contentInset.left
    }
    
    private func setDataFromAPI() {

        let release = viewModel.backdropDetails.release
        let vote = String(viewModel.backdropDetails.vote)
        let genre = viewModel.genreList()
        print(genre)
        
        mainView.synopsisContentLabel.text = viewModel.backdropDetails.synopsis
        mainView.setBackdropInfo(release, vote, genre)
    }
    
    private func setNavigation() {
        navigationItem.title = viewModel.backdropDetails.title
        
        let movieId = String(viewModel.backdropDetails.id)
        let savedStatus = UserDefaultsManager.shared.getDicData(type: .likeButton)[movieId] ?? false
        let heart = UIImage(systemName: savedStatus ? "heart.fill" : "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heart, style: .done, target: self, action: #selector(heartButtonTapped))
    }
    
    @objc func heartButtonTapped() {
        
        UserDefaultsManager.shared.changeDicData(id: viewModel.backdropDetails.id)
 
        // 누르고 네비게이션에 하트 모양 반영되도록
        let key = String(viewModel.backdropDetails.id)
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[key] ?? false
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        
        viewModel.input.tappedHeartBtn.value = ()
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollectionView() {
        [mainView.backdropCollectionView, mainView.castCollectionView, mainView.posterCollectionView].forEach {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.backdropCollectionView:
            return viewModel.output.detailData.value.imgBackdrops.count
        case mainView.castCollectionView:
            return viewModel.output.detailData.value.casts.count
        case mainView.posterCollectionView:
            return viewModel.output.detailData.value.imgPosters.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.backdropCollectionView:
            let backdrop = viewModel.output.detailData.value.imgBackdrops[indexPath.item]

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
            
            let url = NetworkManager.originalUrl + backdrop.filepath
            cell.getBackdropImage(url: url)
            
            return cell
            
        case mainView.castCollectionView:
            let cast = viewModel.output.detailData.value.casts[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            
            if let filepath = cast.profilepath {
                let url = NetworkManager.pathUrl + filepath
                cell.getDataFromAPI(url, cast.name, cast.character)
            } else {
                let url = NetworkManager.defaultPoster
                cell.getDataFromAPI(url, cast.name, cast.character)
            }
  
            cell.cornerRadius()
            
            return cell
            
        case mainView.posterCollectionView:
            let poster = viewModel.output.detailData.value.imgPosters[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            
            let url = NetworkManager.pathUrl + poster.filepath
            cell.getPosterImage(url: url)
            
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let backdropCollectionViewWidth = mainView.backdropCollectionView.frame.width
        
        mainView.pageControl.currentPage = Int(mainView.backdropCollectionView.contentOffset.x / backdropCollectionViewWidth)
    }
}
