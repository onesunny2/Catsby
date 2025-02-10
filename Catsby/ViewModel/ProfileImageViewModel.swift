//
//  ProfileImageViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/8/25.
//

import Foundation

/*
 < 프로필 이미지 설정 기능들 >
 1. 선택한 이미지가 상단에 뜨도록 구현
 ☑️ input 받을 목록: 선택한 이미지
 2. 선택한 이미지 이전 화면으로 전달 -> 역값전달로 로직 교체
 3. 처음 화면 진입했을 때 이전화면의 프로필 이미지와 컬렉션뷰의 이미지가 같으면 테두리 효과 주기
 */

final class ProfileImageViewModel: BaseViewModel {
    
    struct Input {
        let selectedImage: Observable<String> = Observable("")
        let indexPathItem: Observable<Int> = Observable(0)
    }
    
    struct Output {
        let selectedImage: Observable<String> = Observable("")
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    var sendSelectedImage: (() -> ())?
    var cellImage: String = ""
    
    init() {
        print("프로필이미지 VM Init")
        
        input = Input()
        output = Output()
        
        transformBinds()
    }
    
    deinit {
        print("프로필이미지 VM Deinit")
    }
    
    func transformBinds() {
        input.indexPathItem.bind { [weak self] index in
            self?.checkCellImage(index)
        }
        
        input.selectedImage.bind { [weak self] image in
            self?.output.selectedImage.value = image
        }
    }
 
    private func checkCellImage(_ index: Int) {
        cellImage = ProfileImage.imageList[index]
    }
}
