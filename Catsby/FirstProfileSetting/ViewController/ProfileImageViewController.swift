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
        
        // TODO: 질문 - output값의 bind를 해줘야하는 순간의 판단 기준은 무엇인가? 어떨 때는 bind를 안해야 괜찮을 때가 있는 것 같아서...
//        viewModel.outputCellImage.bind { image in
//            cell.profileImageView.image = UIImage(named: image)
//        }
        cell.profileImageView.image = UIImage(named: viewModel.outputCellImage.value)
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
        
        viewModel.inputSelectedImage.value = ProfileImage.imageList[indexPath.item]
        
        viewModel.outputSelectedImage.bind { [weak self] image in
            self?.mainView.mainImageView.image = UIImage(named: image)
        }
        
        viewModel.sendSelectedImage?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        
        cell.profileImageView.stroke(.catsLightgray, 1)
        cell.profileImageView.alpha = 0.5
    }
}
