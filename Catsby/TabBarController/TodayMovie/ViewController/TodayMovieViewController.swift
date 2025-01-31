//
//  TodayMovieViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

final class TodayMovieViewController: UIViewController {
    
    private let mainView = TodayMovieView()
    private let networkManager = NetworkManager.shared
    var trendMovie: [TrendResults] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var selectedMovie = 0  // 영화 상세화면에서 좋아요 반영되었을 때 dataReload를 위해 저장해두는 값
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .catsBlack
        NotificationCenter.default.addObserver(self, selector: #selector(receivedProfile), name: NSNotification.Name("editProfile"), object: nil)
        
        setNavigation()
        setCollectionView()
        getTodayMovieData()
        tapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 무비박스 갯수 반영
        let savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let count = savedDictionary.map{ $0.value }.filter{ $0 == true }.count
        let newtitle = "\(count)개의 무비박스 보관중"
        mainView.profileboxView.movieboxButton.changeTitle(title: newtitle, size: 14, weight: .bold)
        
        // 영화 상세화면에서 좋아요 기능 적용한 것 해당 영화만 데이터 리로드 되도록
        mainView.collectionView.reloadItems(at: [IndexPath(item: selectedMovie, section: 0)])
    }
    
    // 프로필 수정 내용 값 역전달 받기
    @objc func receivedProfile(notification: NSNotification) {
        
        guard let nickname = notification.userInfo?["nickname"] as? String, let image = notification.userInfo?["image"] as? String else { return }
        mainView.profileboxView.nicknameLabel.text = nickname
        mainView.profileboxView.profileImageView.image = UIImage(named: image)
    }
    
    @objc func profileAreaTapped() {
        self.viewTransition(style: .naviModal, vc: EditProfileNicknameViewController())
    }
    
    @objc func searchItemTapped() {
        
        let vc = SearchResultViewController()
        
        vc.isEmptyFirst = true
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
    
    private func tapGesture() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(profileAreaTapped))
        mainView.profileboxView.isUserInteractionEnabled = true
        mainView.profileboxView.addGestureRecognizer(tapgesture)
    }
    
    private func getTodayMovieData() {
        
        networkManager.callRequest(type: TrendMovie.self, api: .trend) { result in
            self.trendMovie = result.results
        } failHandler: {
            print(#function, "error")
        }
    }
    
    private func setNavigation() {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.catsMain, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(searchItemTapped))
        navigationItem.title = "Catsby의 영화세상"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .catsMain
    }
}

extension TodayMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = trendMovie[indexPath.item]
        let key = String(row.id)
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[key]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }

        cell.buttonTapAction = {
            let key = String(row.id)
            var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
            
            savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)

            UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)
            
            // 상단 프로필에 변경된 무비박스 카운트 반영되도록
            let count = savedDictionary.map{ $0.value }.filter{ $0 == true }.count
            let newtitle = "\(count)개의 무비박스 보관중"
            self.mainView.profileboxView.movieboxButton.changeTitle(title: newtitle, size: 14, weight: .bold)

            self.mainView.collectionView.reloadItems(at: [IndexPath(item: indexPath.row, section: 0)])
        }
        
        let url = NetworkManager.pathUrl + row.posterpath
        cell.getData(url: url, title: row.title, plot: row.overview, isLiked: isLiked ?? false)
        cell.posterCornerRadius()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedMovie = indexPath.item
        
        let vc = MovieDetailViewController()
        vc.trendResult = trendMovie[indexPath.item]
        vc.isSearchresult = false
        
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
}
