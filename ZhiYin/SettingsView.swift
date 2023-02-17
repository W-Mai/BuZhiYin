//
//  SettingsView.swift
//  ZhiYin
//
//  Created by W-Mai on 2023/1/15.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("AutoReverse") private var autoReverse = true
    @AppStorage("SpeedProportional") private var speedProportional = true
    @AppStorage("CurrentImageSetString") private var currentImageSet: String?
    @AppStorage("ThemeMode") private var themeMode = 0
    @AppStorage("PlaySpeed") private var playSpeed = 0.5
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ZhiyinEntity.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ZhiyinEntity>
    
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
                    Toggle("速度正比于CPU占用", isOn: $speedProportional).toggleStyle(.switch)
                    HStack {
                        Picker(selection: $currentImageSet, label: Text("图集")) {
                            ForEach(items) {item in
                                Text(item.name!).tag(item.id?.uuidString)
                            }
                        }
                    }.frame(width: 200)
                    HStack {
                        Text("只因速")
                        Slider(value: $playSpeed)
                    }
                }
            }
            .frame(width: 300, height: 350)
            .tabItem {Label("通用", systemImage: "gear")}
            
            Form {
                VStack {
                    Text("🐔🫵🏻🌞🈚️")
                        .font(.system(size: 100)).multilineTextAlignment(.center)
                }.onTapGesture {
                    NSWorkspace.shared.open(URL(string:"https://github.com/W-Mai/ZhiYin")!)
                }
                
            }.frame(width: 300, height: 300)
                .tabItem {Label("关于", systemImage: "info.circle.fill")}
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
