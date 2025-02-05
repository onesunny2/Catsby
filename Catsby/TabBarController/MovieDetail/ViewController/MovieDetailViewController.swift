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
    private let group = DispatchGroup()
    
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
    var searchResult = SearchResults(id: 0, backdrop: "", title: "", overview: "", posterpath: "", genreID: [], releaseDate: "", vote: 0.0)
    var isSearchresult = false
    var heartButtonStatus: (() -> ())? // 검색결과 화면에 하트버튼 상태전달 위한 변수
    
    
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
        
        let synopsis = isSearchresult ?  searchResult.overview : trendResult.overview
        let release = isSearchresult ? searchResult.releaseDate : trendResult.releaseDate
        let vote = isSearchresult ? String(searchResult.vote) : String(trendResult.vote)
        let genreID = isSearchresult ? Array(searchResult.genreID.prefix(2)) : Array(trendResult.genreID.prefix(2))
        
        mainView.synopsisContentLabel.text = synopsis
        
        switch genreID.count {
        case 0:
            let genre = ""
            mainView.setBackdropInfo(release, vote, genre)
        case 1:
            let genre = (Genre.genreList[genreID[0]] ?? "")
            mainView.setBackdropInfo(release, vote, genre)
        case 2:
            let genre: String = (Genre.genreList[genreID[0]] ?? "") + ", " + (Genre.genreList[genreID[1]] ?? "")
            mainView.setBackdropInfo(release, vote, genre)
        default: break
        }
    }
    
    private func getDataAPI() {
       
        // backdrop, poster 정보
        group.enter()
        networkManager.callRequest(type: ImageMovie.self, api: .image(movieID: isSearchresult ? searchResult.id : trendResult.id)) { result in
            self.imageBackdrop = Array(result.backdrops.prefix(5))
            self.imagePosters = result.posters
            self.group.leave()
        } failHandler: {
            print(#function, "error")
            self.group.leave()
        }
        
        // cast 정보
        group.enter()
        networkManager.callRequest(type: CreditMovie.self, api: .credit(movieID: isSearchresult ? searchResult.id : trendResult.id)) { result in
            self.cast = result.cast
            self.group.leave()
        } failHandler: {
            print(#function, "error")
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            self.mainView.backdropCollectionView.reloadData()
            self.mainView.castCollectionView.reloadData()
            self.mainView.posterCollectionView.reloadData()
            
            // 자꾸 처음에 위치가 튀는 것 때문에 설정
            self.setCollectionViewScrollOffset()
        }

    }
    
    private func setNavigation() {
        navigationItem.title = isSearchresult ? searchResult.title : trendResult.title
        
        let movieId = String(isSearchresult ? searchResult.id : trendResult.id)
        let savedStatus = UserDefaultsManager.shared.getDicData(type: .likeButton)[movieId] ?? false
        let heart = UIImage(systemName: savedStatus ? "heart.fill" : "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heart, style: .done, target: self, action: #selector(heartButtonTapped))
    }
    
    @objc func heartButtonTapped() {
        let key = String(isSearchresult ? searchResult.id : trendResult.id)
        var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        
        savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)
        
        UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)
        
        // 누르고 네비게이션에 하트 모양 반영되도록
        let savedStatus = UserDefaultsManager.shared.getDicData(type: .likeButton)[key] ?? false
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: savedStatus ? "heart.fill" : "heart")
        
        heartButtonStatus?()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let backdropCollectionViewWidth = mainView.backdropCollectionView.frame.width
        
        mainView.pageControl.currentPage = Int(mainView.backdropCollectionView.contentOffset.x / backdropCollectionViewWidth)
    }
}
