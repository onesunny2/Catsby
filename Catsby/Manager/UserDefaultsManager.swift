//
//  UserDefaultsManager.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    static let dateformatter = DateFormatter()
    
    func getStringData(type: SaveData) -> String {
        guard let data = UserDefaults.standard.string(forKey: type.saveKey) else { return "" }
        
        return data
    }
    
    func getBoolData(type: SaveData) -> Bool {
        let data = UserDefaults.standard.bool(forKey: type.saveKey)
        
        return data
    }
    
    func getDateData(type: SaveData) -> Date {
        guard let data = UserDefaults.standard.date(forKey: type.saveKey) else { return Date() }
        
        return data
    }
    
    func saveData(value: Any, type: SaveData) {
        UserDefaults.standard.set(value, forKey: type.saveKey)
    }
    
    func resetData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    func dateToString(date: Date) -> String {
        UserDefaultsManager.dateformatter.dateFormat = "yy.MM.dd 가입"
        let savedate = UserDefaultsManager.dateformatter.string(from: date)
        return savedate
    }
}

extension UserDefaultsManager {
    
    enum SaveData: String, CaseIterable {
        case profileName
        case profileImage
        case profileDate
        case firstSaved
        case likeButton
        case recentKeyword
        
        var saveKey: String {
            return self.rawValue
        }
    }
}
