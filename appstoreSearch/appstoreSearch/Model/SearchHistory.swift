//
//  SearchHistory.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

struct SearchHistory {
    private static let key = "SearchHistory"
    private static let capacity = 10
    
    static func get() -> [String] {
        let history = UserDefaults.standard.array(forKey: key)
        return history as? [String] ?? [String]()
    }
    
    static private func set(_ value: [String]) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    ///LRU방식으로 사용
    static func insert(_ value: String) {
        var history = get()
        
        for index in 0..<history.count {
            if history[index] == value {
                history.remove(at: index)
                break
            }
        }
        
        history.insert(value, at: 0)
        
        while history.count > capacity {
            history.removeLast()
        }
        
        set(history)
    }
}
