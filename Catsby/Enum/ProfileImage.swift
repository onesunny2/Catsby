//
//  ProfileImage.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

enum ProfileImage {
    
    static let imageList = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
    static var selectedImage = UserDefaultsManager.shared.getStringData(type: .profileImage)
}
