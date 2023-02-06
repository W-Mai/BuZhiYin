//
//  ZYView.swift
//  ZhiYin
//
//  Created by 王小劣 on 2023/1/10.
//  Collaborator: W-Mai
//

import SwiftUI



struct AutoInvertImage: View {
    @Environment(\.colorScheme) var currentMode
    @AppStorage("ThemeMode") private var themeMode = 0
    var name: String
    var light: NeedInvert
    var dark: NeedInvert
    
    var body: some View {
        VStack {
            let mode: ColorScheme = themeMode == 2 ? currentMode : themeMode == 0 ? .light : .dark
            
            if mode == .light && light == .no || mode == .dark && dark == .no {
                Image(name).resizable()
            } else  {
                Image(name).resizable().colorInvert()
            }
        }
    }
}

struct ZYView: View {
    @StateObject var cpuInfo = CpuUsage()
    
    @AppStorage("AutoReverse") private var autoReverse = true
    @AppStorage("SpeedProportional") private var speedProportional = true
    @AppStorage("CurrentImageSet") private var currentImageSet = 0
    @AppStorage("PlaySpeed") private var playSpeed = 0.5
    @State var imageName = "ZhiyinDefault"
    
    @State var direction = 1
    @State var imageIndex = 0
    
    @State var width: CGFloat
    @State var height: CGFloat
    
    init(width:CGFloat, height: CGFloat ) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        let timer = Timer.publish(every: TimeInterval((( speedProportional ? 1.0001 - Double(cpuInfo.cuse) : Double(cpuInfo.cuse)) / 5 * (1.1 - playSpeed))),
                                  on: .main, in: .common).autoconnect()
        VStack {
            AutoInvertImage(name: imageName,
                            light: imageSet[currentImageSet].light,
                            dark: imageSet[currentImageSet].dark)
            .frame(width: width, height: height)
        }.onReceive(timer) { _ in
            if imageIndex == 0 {
                direction = 1
            }
            if imageIndex >= imageSet[currentImageSet].num - 1 {
                if autoReverse {
                    direction = -1
                } else {
                    direction = 1
                    imageIndex = 0
                }
            }
            
            imageIndex += direction
            imageName = "\(imageSet[currentImageSet].name)\(imageIndex)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZYView(width: 100, height: 100)
    }
}
