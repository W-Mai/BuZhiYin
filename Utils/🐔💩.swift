//
//  🐔💩.swift
//  BuZhiYin
//
//  Created by W-Mai on 2023/4/30.
//

import Foundation

class 🐔💩<🐔: Hashable, 💩> {
    private var 💩🪣 = [🐔: 💩]()
    
    func 👈(_ 🐔: 🐔, 💩📦: @escaping ()-> 💩) -> 💩 {
        if 💩🪣[🐔] == nil {
            💩🪣[🐔] = 💩📦()
        }
        return 💩🪣[🐔]!
    }
    
    func 👈(_ 🐔: 🐔) -> 💩? {
        return 💩🪣[🐔]
    }
    
    func 👉(_ 🐔: 🐔, _ 💩: 💩) -> 💩 {
        💩🪣[🐔] = 💩
        return 💩
    }
    
    func 🔄() {
        💩🪣.removeAll()
    }
}
