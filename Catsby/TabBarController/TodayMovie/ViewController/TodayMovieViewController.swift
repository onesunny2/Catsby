//
//  TodayMovieViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

final class TodayMovieViewController: UIViewController {
    
    let profileboxView = ProfileBoxView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .catsBlack
        setNavigation()
        
        view.addSubview(profileboxView)
        profileboxView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }

    }
    
    @objc func searchItemTapped() {
        
    }
    
    private func setNavigation() {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.catsMain, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(searchItemTapped))
        navigationItem.title = "오늘의 영화"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
    }
}
