//
//  TodayMovieViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class TodayMovieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(UserDefaultsManager.shared.getStringData(type: .profileName))
        print(UserDefaultsManager.shared.getStringData(type: .profileImage))
        print(UserDefaultsManager.shared.getDateData(type: .profileDate))
        
        view.backgroundColor = .systemGreen
    }

}
