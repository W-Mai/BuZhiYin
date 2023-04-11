//
//  SettingsView.swift
//  BuZhiYin
//
//  Created by W-Mai on 2023/1/15.
//

import SwiftUI
import LaunchAtLogin
import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("AutoReverse") private var autoReverse = true
    @AppStorage("SpeedProportional") private var speedProportional = true
    @AppStorage("CurrentImageSetString") private var currentImageSet: String?
    @AppStorage("ThemeMode") private var themeMode = 0
    @AppStorage("PlaySpeed") private var playSpeed = 0.5
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ZhiyinEntity.name, ascending: true)],
        animation: .easeInOut)
    private var items: FetchedResults<ZhiyinEntity>
    
    @State private var isPresented = false
    @State private var pop = false
    
    var body: some View {
        TabView {
            
            // MARK: TAB 1 鸡础设置
            VStack {
                if isPresented {
                    ScrollViewReader { scrollView in
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(items) { item in
                                    let sizeScale = currentImageSet == item.id?.uuidString ? 1.5 : 1
                                    
                                    HStack {
                                        🐔View(entity: item, factor: currentImageSet == item.id?.uuidString ? 0.1 : 0.5).frame(
                                            width: 30 * sizeScale,
                                            height: 30 * sizeScale
                                        )
                                        .cornerRadius(8).animation(.none)
                                        Text(item.name!)
                                        Spacer()
                                        
                                        if currentImageSet == item.id?.uuidString {
                                            EditButtonWithPopover(isPresented: $pop) {
                                                Edit🐔View(item: item)
                                            }
                                        }
                                    }
                                    .padding(4)
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
                                    .scaleEffect(currentImageSet == item.id?.uuidString ? 1 : 0.86)
                                    .onTapGesture {
                                        currentImageSet = item.id?.uuidString
                                    }.id(item.id!.uuidString)
                                }
                                .onChange(of: currentImageSet) { newValue in
                                    withAnimation {
                                        scrollView.scrollTo(currentImageSet, anchor: .center)
                                    }
                                }
                                
                                // 添加新的只因
                                if items.count == 0 {
                                    Button {
                                        _ = PersistenceController.fillWithDefault🐔(context: viewContext)
                                        _ = PersistenceController.save(context: viewContext)
                                        currentImageSet = "EF2FA09B-20C4-4078-84AD-6879DF5D2DC5"
                                    } label: {
                                        HStack {
                                            Label("添加默认小🐔们！！", systemImage: "plus.square")
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding(8)
                                        .background(Color.accentColor)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        )
                                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.accentColor)
                                        )
                                    }.buttonStyle(.plain)
                                    Text("或者")
                                }
                                
                                Button {
                                    let newZhiyin = PersistenceController.createDefault🐔(context: viewContext)
                                    currentImageSet = newZhiyin.id?.uuidString
                                    pop = true
                                    _ = PersistenceController.save(context: viewContext)
                                } label: {
                                    HStack {
                                        Label("+1只🐔！", systemImage: "plus.square.dashed")
                                    }
                                    .padding(8)
                                    .background(Color.secondary.colorInvert())
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.secondary)
                                    )
                                }.buttonStyle(.plain)
                            }
                            .padding(10)
                        }
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke( Color.gray.opacity(0.2), lineWidth: 2)
                                .padding(4)
                        ).onAppear {
                            withAnimation {
                                scrollView.scrollTo(currentImageSet, anchor: .center)
                            }
                        }
                    }.animation(.spring(response: 0.2))}
                
                Form {
                    Picker(selection: $themeMode, label: Text("主\t题")) {
                        Text("明亮").tag(0)
                        Text("暗黑").tag(1)
                        Text("跟随系统").tag(2)
                    }
                    Toggle("自动反转播放", isOn: $autoReverse).toggleStyle(.switch)
                    Toggle("速度正比CPU", isOn: $speedProportional).toggleStyle(.switch)
                    
                    Slider(value: $playSpeed) {
                        Text("只因速")
                    }
                }.padding()
            }
            .padding()
            .frame(width: 300, height: 400)
            .tabItem {Label("鸡础设置", systemImage: "gear")}
            
            // MARK: TAB 2 高只因设置
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Label("通常", systemImage: "paintbrush").font(.subheadline)
                    Form {
                        LaunchAtLogin.Toggle("开🐔自动太美").toggleStyle(.switch).frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke( Color.gray.opacity(0.2), lineWidth: 2)
                )
                
                Form {
                    Label("默认🐔", systemImage: "paintbrush").font(.subheadline)
                    
                    let hasDefault🐔 = PersistenceController.hasDefault🐔(context: viewContext)
                    let labelIcon = hasDefault🐔 ? "trash" : "plus.square"
                    let labelName = hasDefault🐔 ? "删除默认小🐔们！！" : "恢复默认小🐔们！！"
                    let backgroundColor = hasDefault🐔 ? Color.red.brightness(-0.3) : Color.accentColor.brightness(0)
                    
                    Button {
                        if hasDefault🐔 {
                            _ = PersistenceController.cleanWithDefault🐔(context: viewContext)
                        } else {
                            _ = PersistenceController.fillWithDefault🐔(context: viewContext)
                            currentImageSet = "EF2FA09B-20C4-4078-84AD-6879DF5D2DC5"
                        }
                        _ = PersistenceController.save(context: viewContext)
                        
                    } label: {
                        HStack {
                            Label(labelName, systemImage: labelIcon)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(8)
                        .background(backgroundColor)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                    }.buttonStyle(.plain)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke( Color.gray.opacity(0.2), lineWidth: 2)
                )
            }.padding()
                .frame(width: 300)
                .tabItem {Label("高只因设置", systemImage: "gearshape.2")}
            
            // MARK: TAB 3 关于
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
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification), perform: { notification in
            guard let window = notification.object as? NSWindow else { return }
            if window.styleMask.contains(.titled) {
                debugPrint("俺出来了！")
                debugPrint(notification)
                debugPrint(window.identifier?.rawValue ?? "")
                if #available(macOS 13, *) {
                    if window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" {
                        isPresented = true
                    }
                } else {
                    isPresented = true
                }
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification), perform: { notification in
            guard let window = notification.object as? NSWindow else { return }
            if window.styleMask.contains(.titled) {
                debugPrint("俺回去了！")
                debugPrint(notification)
                debugPrint(window.identifier?.rawValue ?? "")
                if #available(macOS 13, *) {
                    if window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" {
                        isPresented = false
                    }
                } else {
                    isPresented = true
                }
            }
        })
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

struct EditButtonWithPopover<Content: View>: View {
    @Binding var isPresented: Bool
    var content: () -> Content
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .foregroundColor(Color.accentColor)
        }.padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: ContentMode.fit)
            .buttonStyle(.plain)
            .popover(isPresented: $isPresented, arrowEdge: Edge.trailing) {
                content()
            }
    }
}

struct Edit🐔View: View {
    @ObservedObject var item: ZhiyinEntity
    
    private var name:  Binding<String> { Binding { return item.name ?? ""   } set: { item.name         = $0 }}
    private var desc:  Binding<String> { Binding { return item.desc ?? ""   } set: { item.desc         = $0 }}
    private var light: Binding<Bool>   { Binding { return item.light_invert } set: { item.light_invert = $0 }}
    private var dark:  Binding<Bool>   { Binding { return item.dark_invert  } set: { item.dark_invert  = $0 }}
    
    @State private var isTargeted:  Bool = false
    @State private var needDeleted: Bool = false
    @State private var isHover:     Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Form {
            HStack {
                VStack {
                    Button {
                        debugPrint("🐔泥太美！")
                    } label: {
                        🐔View(entity: item, factor: 0.1).animation(.none)
                    }
                    .buttonStyle(.plain)
                    .cornerRadius(24)
                    .padding(8)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(lineWidth: 4)
                        }.foregroundColor(.accentColor)
                    )
                    .frame(width: 128, height: 128)
                    .modifier(GifDropModifier(🐔: item))
                    .onHover { hover in
                        isHover = hover
                    }
                    if isHover {
                        Text("// 仅接受GIF, 拽到👆").font(.subheadline).foregroundColor(Color(hue: 0.5, saturation: 0.39, brightness: 0.3))
                    }
                }.animation(.spring())
                
                VStack {
                    Form {
                        Label(item.id!.uuidString, systemImage: "number.square")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        TextField("名字", text: name)
                        TextField("描述", text: desc)
                        Toggle("亮色反转", isOn: light).toggleStyle(.switch)
                        Toggle("暗色反转", isOn: dark).toggleStyle(.switch)
                    }.padding()
                    HStack {
                        Spacer()
                        Button {
                            needDeleted = true
                        } label: {
                            Label("停止练习😭", systemImage: "trash").foregroundColor(.red)
                        }.popover(isPresented: $needDeleted) {
                            HStack {
                                Button {
                                    viewContext.delete(item)
                                } label: {
                                    Image(systemName: "arrowshape.right.fill")
                                    Label("啊啊啊！再点一下就真的停止练习了啊喂！！", systemImage: "trash").foregroundColor(.red)
                                    Image(systemName: "arrowshape.left.fill")
                                }.padding().buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onDisappear {
            _ = PersistenceController.save(context: viewContext)
        }
    }
}
