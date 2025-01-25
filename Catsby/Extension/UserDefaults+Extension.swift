//
//  UserDefaults+Extension.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/25/25.
//

import Foundation

extension UserDefaults {
    
    @discardableResult func date(forKey defaultName: String) -> Date? {
        return self.value(forKey: defaultName) as? Date
    }
}
