//
//  ProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class ProfileNicknameViewController: UIViewController {
    
    private let mainView = ProfileNicknameView()
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
    
    func checkLength(_ textfield: UITextField) {
        guard let count = textfield.text?.count else { return }
        
        switch count {
        case 0:
            mainView.checkNickname.text = " "
        case 1:
            mainView.checkNickname.text = "2글자 이상 10글자 미만으로 설정해주세요."
        case 2...9:
            mainView.checkNickname.text = "사용할 수 있는 닉네임이에요!"
        case 10...:
            mainView.checkNickname.text = "2글자 이상 10글자 미만으로 설정해주세요."
        default:
            print("checkLength: error")
        }
    }
    
    func checkSpecialCharacter(_ text: String) {
        let list = ["@", "#", "$", "%"]
        for index in 0...list.count - 1 {
            if text.contains(list[index]) {
                mainView.checkNickname.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            }
        }
    }
    
    func checkNumber(_ text: String) {
        let result = text.map{ $0.isNumber }
        if result.contains(true) {
            mainView.checkNickname.text = "닉네임에 숫자는 포함할 수 없어요."
        }
    }
}
