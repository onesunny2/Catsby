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
    var movieId: Int = 0
    var synopsis: String = ""
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setNavigation()
        getImageAPI()
        
        setDataFromAPI()
    }
    
    private func setDataFromAPI() {
        mainView.synopsisContentLabel.text = synopsis
    }
    
    private func getImageAPI() {
        networkManager.callRequest(type: ImageMovie.self, api: .image(movieID: movieId)) { result in
            self.imageBackdrop = Array(result.backdrops.prefix(5))
            self.imagePosters = result.posters
        } failHandler: {
            print(#function, "error")
        }
    }
    
    private func setNavigation() {
        navigationItem.title = "영화 제목"
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
        case mainView.castCollectionView: return 4
        case mainView.posterCollectionView: return 3
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.backdropCollectionView:
            let backdrop = imageBackdrop[indexPath.item]
            print(imageBackdrop.count)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
            
            let url = NetworkManager.pathUrl + backdrop.filepath
            cell.getBackdropImage(url: url)
            cell.corderRadius()
            
            return cell
            
        case mainView.castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        case mainView.posterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    
}
