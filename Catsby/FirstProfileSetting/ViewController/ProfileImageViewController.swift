//
//  ProfileImageViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit

final class ProfileImageViewController: UIViewController {
    
    let viewModel = ProfileImageViewModel()
    private let mainView = ProfileImageView()
    
    override func loadView() {
        view = mainView
    }
    
    deinit {
        print("프로필이미지 VC Deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mainImageView.image = UIImage(named: viewModel.input.selectedImage.value)

        navigationItem.title = "프로필 이미지 설정"
        setCollectionView()
        bindVMData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 순환참조 해제 위함
        viewModel.sendSelectedImage = nil
    }
    
    private func bindVMData() {
        viewModel.output.selectedImage.bind { [weak self] image in
            self?.mainView.mainImageView.image = UIImage(named: image)
        }
    }

}

// MARK: collectoionView 설정
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileImage.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        viewModel.input.indexPathItem.value = indexPath.item
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }

        cell.profileImageView.image = UIImage(named: viewModel.cellImage)
        cell.clipImage()
        cell.profileImageView.alpha = 0.5
        
        if viewModel.cellImage == viewModel.input.selectedImage.value {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            cell.profileImageView.stroke(.catsMain, 2)
            cell.profileImageView.alpha = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsMain, 2)
        cell.profileImageView.alpha = 1
        
        viewModel.input.selectedImage.value = ProfileImage.imageList[indexPath.item]
        
        viewModel.sendSelectedImage?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsLightgray, 1)
        cell.profileImageView.alpha = 0.5
    }
}
