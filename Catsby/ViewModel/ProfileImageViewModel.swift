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
 ☑️ output 할 목록: 선택한 이미지
 2. 선택한 이미지 이전 화면으로 전달 -> 역값전달로 로직 교체
 3. 처음 화면 진입했을 때 이전화면의 프로필 이미지와 컬렉션뷰의 이미지가 같으면 테두리 효과 주기
 */

final class ProfileImageViewModel {
    
    // 컬렉션뷰에서 selected된 이미지
    let inputSelectedImage: Observable<String> = Observable("")
    let inputIndexPathItem: Observable<Int> = Observable(0)
    
    let outputCellImage: Observable<String> = Observable("")
    var outputImageIsMatched: Observable<Void> = Observable(())
    
    init() {
        print("프로필이미지 VM Init")
        
        inputIndexPathItem.bind { [weak self] index in
            self?.checkCellImage(index)
        }
        
//        inputSelectedImage.bind { [weak self] _ in
//            self?.checkSelectedImage()
//        }
    }
    
    deinit {
        print("프로필이미지 VM Deinit")
    }
    
    private func checkSelectedImage() {
        
        if outputCellImage.value == inputSelectedImage.value {
            outputImageIsMatched.value = ()
        }
    }
    
    // 전달받은 indexpath로 셀 이미지 내보내기
    private func checkCellImage(_ index: Int) {
        outputCellImage.value = ProfileImage.imageList[index]
    }
}
