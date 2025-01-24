//
//  Bundle+Extension.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

extension Bundle {
    var apiKey: String? {
        return infoDictionary?["APIKey"] as? String
    }
}
