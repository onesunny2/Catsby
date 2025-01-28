//
//  EditProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit

final class EditProfileNicknameViewController: UIViewController {
    
    private let mainView = ProfileNicknameView()
    private let userdefaults = UserDefaultsManager.shared

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = userdefaults.getStringData(type: .profileImage)
        let nickname = userdefaults.getStringData(type: .profileName)

        mainView.completeButton.isHidden = true
        mainView.profileImageView.image = UIImage(named: image)
        mainView.textfield.text = nickname
        mainView.textfield.delegate = self
        mainView.textfield.addTarget(self, action: #selector(checkNicknameCondition), for: .editingChanged)
        setNavigation()
        tapGesture()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        mainView.profileImageView.image = UIImage(named: ProfileImage.selectedImage)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        
        if mainView.checkNickname.text == Comment.pass.rawValue {
            
            guard let text = mainView.textfield.text else { return }
            // 데이터 저장하고
            userdefaults.saveData(value: text, type: .profileName)
            userdefaults.saveData(value: ProfileImage.selectedImage, type: .profileImage)
            
            // 옵저버로 데이터 보내기
            let profileImage = userdefaults.getStringData(type: .profileImage)
            let profileName = userdefaults.getStringData(type: .profileName)
            NotificationCenter.default.post(name: NSNotification.Name("editProfile"), object: nil, userInfo: ["nickname": profileName, "image": profileImage])
            
            dismiss(animated: true)
        }
    }

    private func setNavigation() {
        navigationItem.title = "프로필 편집"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .catsMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        
        let close = UIImage(systemName: "xmark")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: close, style: .done, target: self, action: #selector(closeButtonTapped))
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        mainView.profileImageView.isUserInteractionEnabled = true
        mainView.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        print(#function)
        self.viewTransition(style: .push(animated: true), vc: EditProfileImageViewController())
    }
}

// MARK: textfield 기능 관련
extension EditProfileNicknameViewController: UITextFieldDelegate {
    
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
