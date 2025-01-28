//
//  Comment.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/28/25.
//

import Foundation

enum Comment: String {
    case length = "2글자 이상 10글자 미만으로 설정해주세요."
    case specialCharacter = "닉네임에 @, #, $, %는 포함할 수 없어요"
    case number = "닉네임에 숫자는 포함할 수 없어요."
    case pass = "사용할 수 있는 닉네임이에요!"
    case space = " "
}
