//
//  ProfileNicknameViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

/*
 < 기능 구현 >
 1. 닉네임 조건
 -
 */

class ProfileNicknameViewController: UIViewController {
    
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
    }

}

// MARK: textfield 기능 관련
extension ProfileNicknameViewController: UITextFieldDelegate {
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        checkLength(textField)
        checkSpecialCharacter()
        checkNumber()
        
        return true
    }
    
    func checkLength(_ textfield: UITextField) {
        guard let count = textfield.text?.count else { return }
        
        switch count {
        case 0...1:
            mainView.checkNickname.text = "2글자 이상 10글자 미만으로 설정해주세요."
        case 2...9:
            mainView.checkNickname.text = "사용할 수 있는 닉네임이에요!"
        case 10...:
            mainView.checkNickname.text = "2글자 이상 10글자 미만으로 설정해주세요."
        default:
            print("checkLength: error")
        }
    }
    
    func checkSpecialCharacter() {
        
    }
    
    func checkNumber() {
        
    }
}
