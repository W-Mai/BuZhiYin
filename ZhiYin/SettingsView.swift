//
//  SettingsView.swift
//  ZhiYin
//
//  Created by W-Mai on 2023/1/15.
//

import SwiftUI

struct ImageSetInfo: Identifiable {
    var id:   Int
    var name: String
    var num:  Int
    var desp: String
}

struct SettingsView: View {
    @AppStorage("AutoReverse") private var autoReverse = true
    @AppStorage("CurrentImageSet") private var currentImageSet = 0
    @AppStorage("ThemeMode") private var themeMode = 0
    @AppStorage("PlaySpeed") private var playSpeed = 0.5
    
    var body: some View {
        TabView {
            Form {
                List {
                    HStack(alignment: .center) {
                        ZYView(width: 100, height: 100)
                    }.padding(20)
                        .frame(maxWidth: .infinity)
                    
                    Picker(selection: $themeMode, label: Text("主题")) {
                        Text("明亮").tag(0)
                        Text("暗黑").tag(1)
                        Text("跟随系统").tag(2)
                    }
                    Toggle("自动反转播放", isOn: $autoReverse).toggleStyle(.switch)
                    HStack {
                        Picker(selection: $currentImageSet, label: Text("图集")) {
                            ForEach(imageSet) {item in
                                Text(item.desp).tag(item.id)
                            }
                        }
                    }.frame(width: 200)
                    HStack {
                        Text("只因速")
                        Slider(value: $playSpeed)
                    }
                }
            }
            .frame(width: 300, height: 300)
            .tabItem {Label("通用", systemImage: "gear")}
            
            Form {
                VStack {
                    Text("🐔🫵🏻🌞🈚️")
                        .font(.system(size: 100)).multilineTextAlignment(.center)
                }.onTapGesture {
                    NSWorkspace.shared.open(URL(string:"https://github.com/Eilgnaw/ZhiYin")!)
                }
                
            }.frame(width: 300, height: 300)
                .tabItem {Label("关于", systemImage: "info.circle.fill")}
        }
    }
}
