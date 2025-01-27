//
//  ProfileImageViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit

final class ProfileImageViewController: UIViewController {
    
    private let mainView = ProfileImageView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "프로필 이미지 설정"
        setCollectionView()
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
        
        let selectedImage = ProfileImage.imageList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.profileImageView.image = UIImage(named: selectedImage)
        cell.clipImage()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedImage = ProfileImage.imageList[indexPath.item]

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsMain, 2)
        
        guard let selectedImageView = cell.profileImageView.image else { return }
        mainView.mainImageView.image = selectedImageView
        ProfileImage.selectedImage = selectedImage
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsLightgray, 1)
    }
}
