//
//  Utils.swift
//  ZhiYin
//
//  Created by W-Mai on 2023/2/18.
//

import Foundation
import SwiftUI

struct FriendLinkInfo: Identifiable {
    var id = UUID()
    
    let icon: String
    let title: String
    let desc: String
    let link: URL
}

func clamp<T: Comparable>(_ value: T, lowerBound: T, upperBound: T) -> T {
    return min(max(value, lowerBound), upperBound)
}

func friendLinks() -> [FriendLinkInfo]{
    return [
        FriendLinkInfo(icon: "MenubarX", title: "MenubarX", desc: "一款强大的菜单栏浏览器", link: URL(string: "macappstore://apps.apple.com/cn/app/id1575588022?mt=8&ct=app")!),
    ]
}
