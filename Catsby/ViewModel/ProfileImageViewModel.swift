//
//  ProfileImageViewModel.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/8/25.
//

import Foundation

final class ProfileImageViewModel {
    
    let inputSelectedImage: Observable<String> = Observable("")
    
    init() {
        print("프로필이미지 VM Init")
    }
    
    deinit {
        print("프로필이미지 VM Deinit")
    }
}
