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
    
    @State var showPicker = false
    
    var body: some View {
        TabView {
            Form {
                HStack {
                    List {
                        HStack {
                            Spacer()
                            HStack(alignment: .center) {
                                ZYViewAuto(width: 100, height: 100).animation(.none)
                            }
                            .cornerRadius(20)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 25).colorInvert())
                            .shadow(radius: 1)
                            .onTapGesture {
                                showPicker.toggle()
                            }.animation(.spring())
                            Spacer()
                        }
                        
                        Picker(selection: $themeMode, label: Text("主题")) {
                            Text("明亮").tag(0)
                            Text("暗黑").tag(1)
                            Text("跟随系统").tag(2)
                        }
                        Toggle("自动反转播放", isOn: $autoReverse).toggleStyle(.switch)
                        Toggle("速度正比于CPU占用", isOn: $speedProportional).toggleStyle(.switch)
                        HStack {
                            Text("只因速")
                            Slider(value: $playSpeed)
                        }
                        
                    }
                    if showPicker {
                        ScrollView {
                            Form {
                                ForEach(items) {item in
                                    HStack {
                                        ZYView(entity: item, factor: 0.5).frame(width: 30, height: 30)
                                            .cornerRadius(8).animation(.none)
                                        
                                        Text(item.name!)
                                    }.padding(2)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                 .stroke(currentImageSet == item.id?.uuidString
                                                         ? Color.accentColor
                                                         : Color.clear, lineWidth: 2)
                                                    
                                        )
                                        .frame(height: 30)
                                        .frame(minWidth: 150, maxWidth: 150)
                                        .scaleEffect(currentImageSet == item.id?.uuidString ? 0.9 : 1)
                                        .onTapGesture {
                                            currentImageSet = item.id?.uuidString
                                        }
                                }
                            }.padding([.top, .bottom, .trailing], 8)
                        }
                        .transition(.opacity)
                        .animation(.spring())
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
