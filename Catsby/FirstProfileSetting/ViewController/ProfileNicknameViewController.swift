//
//  ProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class ProfileNicknameViewController: UIViewController {
    
    private let mainView = ProfileNicknameView()
    private let userdefaults = UserDefaultsManager.shared
    private let viewModel = ProfileNicknameViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    deinit {
        print("프로필닉네임 VC Deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = viewModel.randomImage
        print(#function, image)
        mainView.profileImageView.image = UIImage(named: image)
        mainView.textfield.delegate = self
        mainView.textfield.addTarget(self, action: #selector(checkNicknameCondition), for: .editingChanged)
        
        tapGesture()
        bindVMData()
        
        mainView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func bindVMData() {
       
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        mainView.profileImageView.isUserInteractionEnabled = true
        mainView.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        print(#function)
        self.viewTransition(style: .push(animated: true), vc: ProfileImageViewController())
    }
    
    @objc private func completeButtonTapped() {
        
        if mainView.checkNickname.text == Comment.pass.rawValue {
            
            guard let text = mainView.textfield.text else {
                return }
            
            userdefaults.saveData(value: ProfileImage.selectedImage, type: .profileImage)
            print("profile-selected",ProfileImage.selectedImage)
            userdefaults.saveData(value: text, type: .profileName)
            userdefaults.saveData(value: Date(), type: .profileDate)
            userdefaults.saveData(value: true, type: .firstSaved)
            
            self.viewTransition(style: .windowRoot, vc: TabBarController())
        }
    }

}

// MARK: textfield 기능 관련
extension ProfileNicknameViewController: UITextFieldDelegate {
    
    @objc func checkNicknameCondition(textfield: UITextField) {
        guard let text = textfield.text else { return }
        checkLength(textfield)
        checkNumber(text)
        checkSpecialCharacter(text)
    }
    
    private func checkLength(_ textfield: UITextField) {
        guard let count = textfield.text?.count else { return }
        
        switch count {
        case 0:
            mainView.checkNickname.text = Comment.space.rawValue
        case 1:
            mainView.checkNickname.text = Comment.length.rawValue
        case 2...9:
            mainView.checkNickname.text = Comment.pass.rawValue
        case 10...:
            mainView.checkNickname.text = Comment.length.rawValue
        default:
            print("checkLength: error")
        }
    }
    
    private func checkSpecialCharacter(_ text: String) {
        let list = ["@", "#", "$", "%"]
        for index in 0...list.count - 1 {
            if text.contains(list[index]) {
                mainView.checkNickname.text = Comment.specialCharacter.rawValue
            }
        }
    }
    
    private func checkNumber(_ text: String) {
        let result = text.map{ $0.isNumber }
        if result.contains(true) {
            mainView.checkNickname.text = Comment.number.rawValue
        }
    }
}

extension ProfileNicknameViewController {
    private func setNavigation() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.tintColor = .catsMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
    }
}
