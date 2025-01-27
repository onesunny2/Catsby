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
        setNavigation()
        setCollectionView()
        getTodayMovieData()
    }
    
    @objc func searchItemTapped() {
        print(#function)
    }
    
    func getTodayMovieData() {
        
        networkManager.callRequest(type: TrendMovie.self, api: .trend) { result in
            self.trendMovie = result.results
            print(self.trendMovie.count)
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
        
        let url = "https://image.tmdb.org/t/p/w500" + row.posterpath
        cell.getData(url: url, title: row.title, plot: row.overview)
        print(row.posterpath)
        cell.posterCornerRadius()
        
        return cell
    }
}
