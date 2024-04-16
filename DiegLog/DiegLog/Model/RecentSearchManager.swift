//
//  RecentSearchManager.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/17.
//

import Foundation

struct RecentSearchManager {
    
    static let shared = RecentSearchManager()
    
    var keyNmae: String {
        return String(describing: self)
    }
    
    func add(to recentSearchWord: String) {
        var allRecentSearchWord = getAllRecentSearchWord()
        
        if allRecentSearchWord.count == 20 {
            allRecentSearchWord.remove(at: 0)
        }
        
        allRecentSearchWord.append(recentSearchWord)
        UserDefaults.standard.set(allRecentSearchWord, forKey: keyNmae)
    }
    
    func getAllRecentSearchWord() -> [String] {
        return UserDefaults.standard.stringArray(forKey: keyNmae) ?? []
    }
}
