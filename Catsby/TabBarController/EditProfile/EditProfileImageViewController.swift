//
//  EditProfileImageViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import UIKit

final class EditProfileImageViewController: UIViewController {
    
    private let mainView = ProfileImageView()
    
    var selectedNewImage: (() -> ())?
    var currentImage = UIImage()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "프로필 이미지 편집"
        setCollectionView()
    }

}

// MARK: collectoionView 설정
extension EditProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        cell.profileImageView.alpha = 0.5
        
        if cell.profileImageView.image == mainView.mainImageView.image {
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
        
        guard let selectedImageView = cell.profileImageView.image else { return }
        mainView.mainImageView.image = selectedImageView
        currentImage = selectedImageView
        selectedNewImage?()  // 이전화면에 선택한 이미지 값전달
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsLightgray, 1)
        cell.profileImageView.alpha = 0.5
    }
}
