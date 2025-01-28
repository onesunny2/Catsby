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

        mainView.completeButton.isHidden = true
        setNavigation()
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        
        //        if mainView.checkNickname.text == Comment.pass.rawValue {
        
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

    private func setNavigation() {
        navigationItem.title = "프로필 편집"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .catsMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        
        let close = UIImage(systemName: "xmark")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: close, style: .done, target: self, action: #selector(closeButtonTapped))
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
    }
}
