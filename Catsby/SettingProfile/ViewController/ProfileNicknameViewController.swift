//
//  ProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

class ProfileNicknameViewController: UIViewController {
    
    private let mainView = ProfileNicknameView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "프로필 설정"
    }

}
