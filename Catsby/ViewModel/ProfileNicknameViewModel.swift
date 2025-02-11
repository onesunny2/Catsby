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
 4. 완료 버튼 액션
    => 화면에서 사용자가 입력한 닉네임(input)에 따른 조건 레이블(input)이 Comment 열거형의 원시값과 동일하다면 순차적으로 값 저장
    ☑️ input 받아야 하는 목록
    - 입력한 닉네임 / 조건 레이블의 text / 선택한 이미지
    ☑️ output 해야하는 목록
    - 화면전환 액션을 위한 Void
 5. 닉네임 Valid 조건
    - 기존에는 길이 / 특수문자 / 숫자 포함을 별개로 뒀었는데 다 하나의 액션으로 포함하도록 변경
    ☑️ input 받을 목록: 입력한 닉네임
    ☑️ output 할 목록: 각 조건에 맞는 조건 label들
 
 < 고민되는 부분 >
 - 선택한 이미지 보관하고 저장하는 로직 바꾸기
    ㄴ 현재는 열거형의 타입프로퍼티를 사용하고 있는데 이를 뷰모델에 currentImage라는 변수를 두어 제어하고 이미지 선택 화면과는 값 역전달로 주고받아보기
 
 🥕🥕🥕🥕MBTI 로직 오류 여행기🥕🥕🥕🥕
 (1차) cellForRowAt에 output 2개 bind 설정 & indexPath.item 옵저버블 관리 -> 마지막 인덱스만 적용됨
 (2차) bind는 한번만 되어야하는데 여러번 되어서 그런 것 같아 viewDidLoad로 옮김 -> collectionView 그려지는 타이밍과 어긋나서 아무 작동 안함
 (3차) viewDidAppear로 옮김 -> 똑같음
 (4차) indexpath.item을 하나의 옵저버블로 관리하니까 결국 감시자가 마지막으로 감시한건 마지막 item이었음 -> 옵저버블에서 제거 but 실패
 (5차) 하나의 로직 감시자로 4개의 셀을 관리하니 결국 마지막 셀로만 작용함 -> bool값을 배열로 관리 -> 근데 바보같이 감시자 분리한다면서 bool값만 배열로 둬서 결국 감시자가 똑같은건 ....
 (6차) 감시자 자체를 배열로 두고, 이를 indexpath.item을 인덱스로 받아서 해결....
 p.s. 언젠가부터 output은 셀 내부로 들어갔는데 그건 기억이 희미...
 
 */

final class ProfileNicknameViewModel: BaseViewModel {
    
    struct Input {
        let nickname: Observable<String?> = Observable("")
        let completeButton: Observable<Void> = Observable(())
        let mbtiButtonAction: Observable<(Int, Int)> = Observable((0, 0))
        var isCompleteStatus: Observable<Void> = Observable(())
    }
    
    struct Output {
        let invalidText: Observable<String> = Observable("")
        let isNicknameError: Observable<Bool> = Observable(false)
        let viewTransition: Observable<Void> = Observable(())
        let isCompleted: Observable<Bool> = Observable(false)
        var isTopOn: [Observable<Bool>] = []
        var isBottomOn: [Observable<Bool>] = []
        let mbtiSelectedCount: Observable<Int> = Observable(0)
        var isCompletePossible: Observable<Bool> = Observable(false)
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    private let userDefaults = UserDefaultsManager.shared
    let mbtiList = [["E", "I"], ["S", "N"], ["T", "F"], ["J", "P"]]
    
    var currentSelectedImage: String = ""
    let randomImage = ProfileImage.imageList.randomElement() ?? "profile_10"
    
    init() {
        print("프로필닉네임 VM Init")
        
        input = Input()
        output = Output()
        
        valueSetting()
        transformBinds()
    }
    
    deinit {
        print("프로필닉네임 VM Deinit")
    }
    
    func transformBinds() {
        input.nickname.bind { [weak self] _ in
            self?.checkNicknameCondition()
        }
        
        input.completeButton.lazyBind { [weak self] _ in
            self?.tappedCompleteButton()
        }
        
        input.mbtiButtonAction.lazyBind { [weak self] index, tag in
            self?.mbtiButtonLogic(index, tag)
        }
        
//        input.isCompleteStatus.bind { [weak self] _ in
//            self?.checkButtonStatus()
//        }
    }
    
    private func valueSetting() {
        currentSelectedImage = randomImage
        
        for _ in 0...3 {  // 초기에 모두 OFF인 상태
            output.isTopOn.append(Observable(false))
            output.isBottomOn.append(Observable(false))
        }
    }
    
//    private func checkButtonStatus() {
//        output.isCompletePossible = output.isCompleted.value && (output.mbtiSelectedCount.value == 4)
//    }
    
    private func checkNicknameCondition() {
        
        guard let text = input.nickname.value else {
            print(#function, "nil")
            return
        }
        
        // 특수문자
        for character in text {
            if "@#$%".contains(character) {
                output.invalidText.value = Comment.specialCharacter.rawValue
                output.isNicknameError.value = true
                output.isCompleted.value = false
                return
            }
        }
        
        // 숫자
        if text.contains(/\d/) {
            output.invalidText.value = Comment.number.rawValue
            output.isNicknameError.value = true
            output.isCompleted.value = false
            return
        }
        
        // 길이 체크
        let count = text.count
        switch count {
        case 0:
            output.invalidText.value = Comment.space.rawValue
            output.isNicknameError.value = false
            output.isCompleted.value = false
        case 2...9:
            output.invalidText.value = Comment.pass.rawValue
            output.isNicknameError.value = false
            output.isCompleted.value = true
        default:
            output.invalidText.value = Comment.length.rawValue
            output.isNicknameError.value = true
            output.isCompleted.value = false
        }
        
        output.isCompletePossible.value = (output.invalidText.value == Comment.pass.rawValue) && (output.mbtiSelectedCount.value == 4)
    }
    
    private func tappedCompleteButton() {
        
        if (output.invalidText.value == Comment.pass.rawValue) && (output.mbtiSelectedCount.value == 4) {

            guard let text = input.nickname.value else {
                print("text nil")
                return
            }

            userDefaults.saveData(value: currentSelectedImage, type: .profileImage)
            userDefaults.saveData(value: text, type: .profileName)
            userDefaults.saveData(value: Date(), type: .profileDate)
            userDefaults.saveData(value: true, type: .firstSaved)
            
            output.viewTransition.value = ()
        }
    }
    
    private func mbtiButtonLogic(_ index: Int, _ tag: Int) {
        
        if tag == 0 {
            
            if output.isTopOn[index].value && !output.isBottomOn[index].value {
                output.isTopOn[index].value = false
            } else if !output.isTopOn[index].value && !output.isBottomOn[index].value {
                output.isTopOn[index].value = true
            } else if !output.isTopOn[index].value && output.isBottomOn[index].value {
                output.isTopOn[index].value = true
                output.isBottomOn[index].value = false
            }
            
        } else if tag == 1 {
            
            if output.isBottomOn[index].value && !output.isTopOn[index].value {
                output.isBottomOn[index].value = false
            } else if !output.isBottomOn[index].value && !output.isTopOn[index].value {
                output.isBottomOn[index].value = true
            } else if !output.isBottomOn[index].value && output.isTopOn[index].value {
                output.isBottomOn[index].value = true
                output.isTopOn[index].value = false
            }
        }
        
        let topCount = output.isTopOn.filter { $0.value == true }.count
        let bottomCount = output.isBottomOn.filter { $0.value == true }.count
        
        output.mbtiSelectedCount.value = topCount + bottomCount
        output.isCompletePossible.value = (output.invalidText.value == Comment.pass.rawValue) && (output.mbtiSelectedCount.value == 4)
    }
}
