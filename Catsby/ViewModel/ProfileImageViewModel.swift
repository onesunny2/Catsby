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
        print("ProfileImage VM Init")
    }
    
    deinit {
        print("ProfileImage VM Deinit")
    }
}
