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

        mainView.profileImageView.image = UIImage(named: viewModel.currentSelectedImage)

        mainView.textfield.delegate = self
        mainView.textfield.addTarget(self, action: #selector(checkNicknameCondition), for: .editingChanged)
        
        setNavigation()
        tapGesture()
        bindVMData()
        
        mainView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func bindVMData() {
        viewModel.outputInvalidText.bind { [weak self] _ in
            self?.mainView.checkNickname.text = self?.viewModel.outputInvalidText.value
        }
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        mainView.profileImageView.isUserInteractionEnabled = true
        mainView.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        print(#function)
        let vc = ProfileImageViewController()
        vc.viewModel.inputSelectedImage.value = viewModel.currentSelectedImage
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
    
    @objc private func completeButtonTapped() {
        
        viewModel.inputCompleteButton.value = ()
        
        viewModel.outputViewTransition.bind { [weak self] _ in
            self?.viewTransition(style: .windowRoot, vc: TabBarController())
        }
    }
}

// MARK: textfield 기능 관련
extension ProfileNicknameViewController: UITextFieldDelegate {
    
    @objc func checkNicknameCondition(textfield: UITextField) {
        viewModel.inputNickname.value = textfield.text
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
