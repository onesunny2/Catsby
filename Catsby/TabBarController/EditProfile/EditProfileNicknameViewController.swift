//
//  EditProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit

final class EditProfileNicknameViewController: UIViewController {
    
    private let mainView = ProfileNicknameView()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.completeButton.isHidden = true
    }

}
