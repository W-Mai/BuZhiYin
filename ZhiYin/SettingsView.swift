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
            VStack {
                HStack(alignment: .center) {
                    ZYViewAuto(width: 100, height: 100).animation(.none)
                }
                .cornerRadius(20)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 25).colorInvert())
                .shadow(radius: 1)
                .animation(.spring(response: 0.3))
                .padding()
                
                Form {
                    Picker(selection: $themeMode, label: Text("主\t题")) {
                        Text("明亮").tag(0)
                        Text("暗黑").tag(1)
                        Text("跟随系统").tag(2)
                    }
                    Toggle("自动反转播\n放", isOn: $autoReverse).toggleStyle(.switch)
                    Toggle("速度正比于\nCPU占用", isOn: $speedProportional).toggleStyle(.switch)
                    HStack {
                        Text("只因速")
                        Slider(value: $playSpeed)
                    }
                }.padding([.horizontal])
                
                ScrollView {
                    ForEach(items) { item in
                        let sizeScale = currentImageSet == item.id?.uuidString ? 1.5 : 1
                        HStack {
                            ZYView(entity: item, factor: 0.5).frame(
                                width: 30 * sizeScale,
                                height: 30 * sizeScale
                            )
                            .cornerRadius(8).animation(.none)
                            Text(item.name!)
                            Spacer()
                        }.padding(4)
                            .background(Color.secondary.colorInvert())
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(currentImageSet == item.id?.uuidString
                                        ? Color.accentColor
                                        : Color.clear, lineWidth: 2)
                            )
                            .frame(height: 32 * sizeScale)
                            .scaleEffect(currentImageSet == item.id?.uuidString ? 1 : 0.95)
                            .onTapGesture {
                                currentImageSet = item.id?.uuidString
                            }
                    }.padding(10)
                        .animation(.spring(response: 0.2))
                }.padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous).stroke( Color.gray, lineWidth: 2).padding(4)
                    )
                
            }.frame(width: 300, height: 500)
                .tabItem {Label("鸡础设置", systemImage: "gear")}
            
            
            Form {
                Spacer()
                VStack {
                    Text("🐔🫵🏻\n🌞🈚️")
                        .font(.system(size: 80)).multilineTextAlignment(.center)
                }.onTapGesture {
                    NSWorkspace.shared.open(URL(string:"https://github.com/W-Mai/BuZhiYin")!)
                }.frame(maxWidth: .infinity, minHeight: 200)
                Spacer(minLength: 25)
                FriendLinksView()
            }.padding([.vertical]).frame(width: 300, height: 360)
                .tabItem {Label("关于", systemImage: "info.circle.fill")}
        }
        
    }
}

struct FriendLinksView: View {
    var body: some View {
        VStack {
            let frientlinks = friendLinks()
            if frientlinks.count > 0 {
                Text("- 更多推荐 -").frame(maxWidth: .infinity).foregroundColor(.gray)
                ScrollView {
                    ForEach(frientlinks) { frientlink in
                        HStack {
                            Image(frientlink.icon).resizable().frame(width: 50, height: 50).cornerRadius(12, antialiased: true).shadow(color: .gray.opacity(0.1), radius: 2)
//                            Spacer()
                            VStack(alignment: .leading) {
                                Text(frientlink.title)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text(frientlink.desc).font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("查看").padding().foregroundColor(Color.accentColor)
                        }.frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.primary.colorInvert())
                            .cornerRadius(12)
                            .onTapGesture {
                                NSWorkspace.shared.open(frientlink.link)
                            }
                    }
                }
            }
        }.padding([.horizontal])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
