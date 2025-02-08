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
        
        mainView.mainImageView.image = UIImage(named: viewModel.inputSelectedImage.value)

        navigationItem.title = "프로필 이미지 설정"
        setCollectionView()
        bindVMData()
    }
    
    private func bindVMData() {
        
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

        viewModel.inputIndexPathItem.value = indexPath.item
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        viewModel.outputCellImage.bind { image in
            cell.profileImageView.image = UIImage(named: image)
        }
        cell.clipImage()
        cell.profileImageView.alpha = 0.5
        
        

        // TODO: 질문- 왜 아래로직으로는 모든 셀이 선택되는 것인지
//        viewModel.outputImageIsMatched.bind { _ in
//            cell.isSelected = true
//            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
//            cell.profileImageView.stroke(.catsMain, 2)
//            cell.profileImageView.alpha = 1
//        }
        
        if viewModel.outputCellImage.value == viewModel.inputSelectedImage.value {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsLightgray, 1)
        cell.profileImageView.alpha = 0.5
    }
}
