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
        setCollectionView()
        bindVMData()
        
        mainView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func bindVMData() {
        viewModel.output.invalidText.bind { [weak self] _ in
            self?.mainView.checkNickname.text = self?.viewModel.output.invalidText.value
        }
        
        viewModel.output.isNicknameError.bind { [weak self] isError in
            self?.mainView.checkNickname.textColor = isError ? .catsRed : .catsMain
        }

        viewModel.output.isCompletePossible.bind { [weak self] value in
            self?.mainView.completeButton.configuration?.baseBackgroundColor = value ? .catsMain : .catsDisabled
        }
        
        viewModel.output.viewTransition.lazyBind { [weak self] _ in
            self?.viewTransition(style: .windowRoot, vc: TabBarController())
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
        vc.viewModel.input.selectedImage.value = viewModel.currentSelectedImage
        
        vc.viewModel.sendSelectedImage = { [weak self] in
            
            guard let self else { return }
            
            let image = vc.viewModel.input.selectedImage.value
            mainView.profileImageView.image = UIImage(named: image)
            
            viewModel.currentSelectedImage = image
        }
       
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
    
    @objc private func completeButtonTapped() {
        
        viewModel.input.completeButton.value = ()
    }
}

// MARK: textfield 기능 관련
extension ProfileNicknameViewController: UITextFieldDelegate {
    
    @objc func checkNicknameCondition(textfield: UITextField) {
        viewModel.input.nickname.value = textfield.text
    }
}

extension ProfileNicknameViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    private func setCollectionView() {
        mainView.mbtiCollectionView.delegate = self
        mainView.mbtiCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mbtiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let labelList = viewModel.mbtiList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.id, for: indexPath) as? MBTICollectionViewCell else { return UICollectionViewCell() }
 
        cell.topButton.changeTitle(title: labelList[0], size: 20, weight: .regular)
        cell.bottomButton.changeTitle(title: labelList[1], size: 20, weight: .regular)
        
        cell.buttonAction = { [weak self] tag in
            self?.viewModel.input.mbtiButtonAction.value = (indexPath.item, tag)
        }
        
        cell.configBind(viewModel, index: indexPath.item)
 
        return cell
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
