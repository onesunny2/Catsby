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
    private let networkManager = NetworkManager.shared
    
    private var imageBackdrop: [ImageBackdrops] = [] {
        didSet {
            mainView.backdropCollectionView.reloadData()
        }
    }
    private var imagePosters: [ImagePosters] = [] {
        didSet {
            mainView.posterCollectionView.reloadData()
        }
    }
    private var cast: [CreditCast] = [] {
        didSet {
            mainView.castCollectionView.reloadData()
        }
    }
    
    var trendResult = TrendResults(backdrop: "", id: 0, title: "", overview: "", posterpath: "", genreID: [], releaseDate: "", vote: 0)
    
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setNavigation()
        getDataAPI()
        setDataFromAPI()
        
        mainView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
    
    private func setDataFromAPI() {
        
        let synopsis = trendResult.overview
        let release = trendResult.releaseDate
        let vote = String(trendResult.vote)
        let genreID = Array(trendResult.genreID.prefix(2))
        let genre: String = (Genre.genreList[genreID[0]] ?? "") + ", " + (Genre.genreList[genreID[1]] ?? "")
        
        mainView.synopsisContentLabel.text = synopsis
        mainView.setBackdropInfo(release, vote, genre)
    }
    
    private func getDataAPI() {
        // backdrop, poster 정보
        networkManager.callRequest(type: ImageMovie.self, api: .image(movieID: trendResult.id)) { result in
            self.imageBackdrop = Array(result.backdrops.prefix(5))
            self.imagePosters = result.posters
        } failHandler: {
            print(#function, "error")
        }
        
        // cast 정보
        networkManager.callRequest(type: CreditMovie.self, api: .credit(movieID: trendResult.id)) { result in
            self.cast = result.cast
        } failHandler: {
            print(#function, "error")
        }

    }
    
    private func setNavigation() {
        navigationItem.title = trendResult.title
        let heart = UIImage(systemName: "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heart, style: .done, target: self, action: #selector(heartButtonTapped))
    }
    
    @objc func heartButtonTapped() {
        print(#function)
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
        case mainView.backdropCollectionView: return imageBackdrop.count
        case mainView.castCollectionView: return cast.count
        case mainView.posterCollectionView: return imagePosters.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.backdropCollectionView:
            let backdrop = imageBackdrop[indexPath.item]

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
            
            cell.pageControl.currentPage = indexPath.item
            
            let url = NetworkManager.originalUrl + backdrop.filepath
            cell.getBackdropImage(url: url)
            
            return cell
            
        case mainView.castCollectionView:
            let cast = cast[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            
            if let filepath = cast.profilepath {
                let url = NetworkManager.pathUrl + filepath
                cell.getDataFromAPI(url, cast.name, cast.character)
            } else {
                let url = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYaqjTuNYAbIxAk0GzMiX8-ah3Q63B8cIBMyFJE1zx-4Ty8ZIOSAneIuNysLOXvIffm2o&usqp=CAU"
                cell.getDataFromAPI(url, cast.name, cast.character)
            }
  
            cell.cornerRadius()
            
            return cell
            
        case mainView.posterCollectionView:
            let poster = imagePosters[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            
            let url = NetworkManager.pathUrl + poster.filepath
            cell.getPosterImage(url: url)
            
            return cell
            
        default: return UICollectionViewCell()
        }
    }
}
