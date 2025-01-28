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
        print(#function)
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
        
        cell.heartButton.tag = indexPath.item
        cell.heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        let url = NetworkManager.pathUrl + row.posterpath
        cell.getData(url: url, title: row.title, plot: row.overview, isLiked: isLiked ?? false)
        cell.posterCornerRadius()
        
        return cell
    }
    
    @objc private func heartButtonTapped(_ sender: UIButton) {
        
        let row = trendMovie[sender.tag]
        let key = String(row.id)
        var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        
        savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)

        UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)

        mainView.collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
}
