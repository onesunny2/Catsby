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
    
    func dateToString(date: Date) -> String {
        UserDefaultsManager.dateformatter.dateFormat = "yy.MM.dd 가입"
        let savedate = UserDefaultsManager.dateformatter.string(from: date)
        return savedate
    }
}

extension UserDefaultsManager {
    
    enum SaveData {
        case profileName(name: String)
        case profileImage(name: String)
        case profileDate(saveDate: Date)
        case firstSaved(isSaved: Bool)
        case likeButton(isClicke: Bool)
        case recentKeyword(keyword: String)
        
        var saveKey: String {
            switch self {
            case .profileName: "profileName"
            case .profileImage: "profileImage"
            case .profileDate: "profileDate"
            case .firstSaved: "firstSaved"
            case .likeButton: "likeButton"
            case .recentKeyword: "recentKeyword"
            }
        }
        
        func saveUserdefaults() {
            switch self {
            case let .profileName(name):
                UserDefaults.standard.set(name, forKey: self.saveKey)
            case let .profileImage(name):
                UserDefaults.standard.set(name, forKey: self.saveKey)
            case let .profileDate(saveDate):
                UserDefaults.standard.set(saveDate, forKey: self.saveKey)
            case let .firstSaved(isSaved):
                UserDefaults.standard.set(isSaved, forKey: self.saveKey)
            case let .likeButton(isClicke):
                UserDefaults.standard.set(isClicke, forKey: self.saveKey)
            case let .recentKeyword(keyword):
                UserDefaults.standard.set(keyword, forKey: self.saveKey)
            }
        }
        
        func getUserdefaults() {
            switch self {
            case let .profileName(name):
                UserDefaults.standard.string(forKey: self.saveKey)
            case let .profileImage(name):
                UserDefaults.standard.string(forKey: self.saveKey)
            case let .profileDate(saveDate):
                UserDefaults.standard.date(forKey: self.saveKey)
            case let .firstSaved(isSaved):
                UserDefaults.standard.bool(forKey: self.saveKey)
            case let .likeButton(isClicke):
                UserDefaults.standard.bool(forKey: self.saveKey)
            case let .recentKeyword(keyword):
                UserDefaults.standard.string(forKey: self.saveKey)
            }
        }
    }
}
