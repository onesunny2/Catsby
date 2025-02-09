//
//  ProfileNicknameViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/7/25.
//

import Foundation

/*
 < 현재 프로필 닉네임 설정에 있는 기능 >
 1. viewDidLoad에서 랜덤 이미지 띄워주기
    ☑️ output 목록: 랜덤 이미지
 2. 탭제스쳐는 로직인가?
    ㄴ 로직이라면 어떻게 뷰모델에 넣을 수 있지? => VC에서만 할 수 있는 조건들이라 분리하지 않겠음
 3. 프로필 이미지 탭 액션 -> 다음 화면으로 선택한 이미지 넘겨주기(이건 profileImageViewModel에서 받아야 할듯)
    => 랜덤으로 나온 이미지를 전달해주는 것
 4. ⭐️ 완료 버튼 액션
    => 화면에서 사용자가 입력한 닉네임(input)에 따른 조건 레이블(input)이 Comment 열거형의 원시값과 동일하다면 순차적으로 값 저장
    ☑️ input 받아야 하는 목록
    - 입력한 닉네임 / 조건 레이블의 text / 선택한 이미지
    ☑️ output 해야하는 목록
    - 화면전환 액션을 위한 Void -> 이거 대신 일치 조건에 따라 Bool값을 output해서 그거에 따라 화면전환을 밖에서? 근데 이것도 조건문이 붙어서 이것조차 로직같음 기존대로 ㄱㄱ
 5. ⭐️⭐️ 닉네임 Valid 조건
    - 기존에는 길이 / 특수문자 / 숫자 포함을 별개로 뒀었는데 다 하나의 액션으로 포함하도록 변경
    ☑️ input 받을 목록: 입력한 닉네임
    ☑️ output 할 목록: 각 조건에 맞는 조건 label들
 
 < 고민되는 부분 >
 - 너무 작은 단위로 프로퍼티를 관리하니까 (ex. 하나의 이벤트 단위보다는 String, Int 등의 단일 객체를) 해당 프로퍼티가 여러 개 사용될 때 어려움을 느낌
   => 그럼 조금 큰 덩어리로 묶어서 하나의 로직? 액션?을 넘기려고 해보자(랜덤 이미지나 이런 예외적인 경우 빼고)
 
 - 선택한 이미지 보관하고 저장하는 로직 바꾸기
    ㄴ 현재는 열거형의 타입프로퍼티를 사용하고 있는데 이를 뷰모델에 currentImage라는 변수를 두어 제어하고 이미지 선택 화면과는 값 역전달로 주고받아보기
 */

final class ProfileNicknameViewModel {
    
    private let userDefaults = UserDefaultsManager.shared
    let mbtiList = [["E", "I"], ["S", "N"], ["T", "F"], ["J", "P"]]
    
    var currentSelectedImage: String = ""
    let randomImage = ProfileImage.imageList.randomElement() ?? "profile_10"
    
    let inputNickname: Observable<String?> = Observable("")
    let inputCompleteButton: Observable<Void> = Observable(())
    
    let outputInvalidText: Observable<String> = Observable("")
    let outputViewTransition: Observable<Void> = Observable(())
    
    init() {
        print("프로필닉네임 VM Init")
        currentSelectedImage = randomImage
        
        inputNickname.bind { [weak self] _ in
            self?.checkNicknameCondition()
        }
        
        inputCompleteButton.lazyBind { [weak self] _ in
            self?.tappedCompleteButton()
        }
    }
    
    deinit {
        print("프로필닉네임 VM Deinit")
    }
    
    private func checkNicknameCondition() {
        
        guard let text = inputNickname.value else {
            print(#function, "nil")
            return
        }
        
        // 특수문자
        for character in text {
            if "@#$%".contains(character) {
                outputInvalidText.value = Comment.specialCharacter.rawValue
                return
            }
        }
        
        // 숫자
        if text.contains(/\d/) {
            outputInvalidText.value = Comment.number.rawValue
            return
        }
        
        // 길이 체크
        let count = text.count
        switch count {
        case 0:
            outputInvalidText.value = Comment.space.rawValue
        case 2...9:
            outputInvalidText.value = Comment.pass.rawValue
        default:
            outputInvalidText.value = Comment.length.rawValue
        }
    }
    
    private func tappedCompleteButton() {
        
        if outputInvalidText.value == Comment.pass.rawValue {
            
            guard let text = inputNickname.value else {
                print("text nil")
                return
            }
            
            userDefaults.saveData(value: currentSelectedImage, type: .profileImage)
            userDefaults.saveData(value: text, type: .profileName)
            userDefaults.saveData(value: Date(), type: .profileDate)
            userDefaults.saveData(value: true, type: .firstSaved)
            
            outputViewTransition.value = ()
        }
    }
}
