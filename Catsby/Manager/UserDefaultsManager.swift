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
    
    private func dateToString(date: Date) -> String {
        UserDefaultsManager.dateformatter.dateFormat = "yy.MM.dd 가입"
        let savedate = UserDefaultsManager.dateformatter.string(from: date)
        return savedate
    }
}

// MARK: 저장해야 할 데이터의 목록
extension UserDefaultsManager {
    enum SaveData: String {
        case profileName  // String
        case profileImage // String
        case profileDate  // Date
        case firstSaved  // Bool
        case likeButton  // [id(Int): Bool]
        case recentKeyword  // String 배열 저장
        
        var saveKey: String {
            return self.rawValue
        }
    }
}

// MARK: UserDefaults 관련 메서드들
extension UserDefaultsManager {
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
    
    func getArrayData(type: SaveData) -> [String] {
        guard let data = UserDefaults.standard.object(forKey: type.saveKey) as? [String] else { return [] }
        
        return data
    }
    
    func getDicData(type: SaveData) -> [Int:Bool] {
        guard let data = UserDefaults.standard.object(forKey: type.saveKey) as? [Int: Bool] else { return [:] }
        
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
}
