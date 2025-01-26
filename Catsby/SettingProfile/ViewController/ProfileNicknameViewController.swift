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
    
    let randomImage = ProfileImage.imageList.randomElement() ?? ""
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.profileImageView.image = UIImage(named: randomImage)
        navigationItem.title = "프로필 설정"
        mainView.textfield.delegate = self
        mainView.textfield.addTarget(self, action: #selector(checkNicknameCondition), for: .editingChanged)
        
        tapGesture()
        
        mainView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
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
            
            userdefaults.saveData(value: randomImage, type: .profileImage)
            userdefaults.saveData(value: text, type: .profileName)
            userdefaults.saveData(value: Date(), type: .profileDate)
            userdefaults.saveData(value: true, type: .firstSaved)
            
            self.viewTransition(style: .windowRoot, vc: TodayMovieViewController())
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
    enum Comment: String {
        case length = "2글자 이상 10글자 미만으로 설정해주세요."
        case specialCharacter = "닉네임에 @, #, $, %는 포함할 수 없어요"
        case number = "닉네임에 숫자는 포함할 수 없어요."
        case pass = "사용할 수 있는 닉네임이에요!"
        case space = " "
    }
}
