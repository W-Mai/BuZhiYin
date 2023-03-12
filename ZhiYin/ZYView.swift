//
//  ZYView.swift
//  ZhiYin
//
//  Created by 王小劣 on 2023/1/10.
//  Collaborator: W-Mai
//

import SwiftUI

/*
 0.1       1
 0.2       0.012
 0.012     8
 */

let minInterval: Float = 0.012 // 80FPS

struct AutoInvertImage: View {
    @Environment(\.colorScheme) var currentMode
    @AppStorage("ThemeMode") private var themeMode = 0
    var data: Image
    var light: Bool
    var dark: Bool
    
    var body: some View {
        VStack {
            let mode: ColorScheme = themeMode == 2 ? currentMode : themeMode == 0 ? .light : .dark
            
            if mode == .light && light == false || mode == .dark && dark == false {
                data.resizable()
            } else  {
                data.resizable().colorInvert()
            }
        }
    }
}

struct ZYView: View {
    var entity: ZhiyinEntity?
    var factor: Float
    var autoReverse = true
    
    @State var direction = 1
    @State var imageIndex = 0
    
    var body: some View {
        let timer = Timer.publish(every: TimeInterval(factor),
                                  on: .main,
                                  in: .common).autoconnect()
        
        VStack {
            if entity != nil {
                AutoInvertImage(
                    data: Image(entity!.getImage(imageIndex)!, scale: 1, label: Text("ZhiyinView")),
                    light: entity!.light_invert,
                    dark: entity!.dark_invert
                )
            } else {
                AutoInvertImage(data: Image("ZhiyinDefault"), light: false, dark: true)
            }
        }.onReceive(timer) { _ in
            guard let frame_num = entity?.frame_num else {
                return
            }
            if imageIndex == 0 {
                direction = 1
            }
            if imageIndex >= frame_num - 1 {
                if autoReverse {
                    direction = -1
                } else {
                    direction = 1
                    imageIndex = 0
                }
            }
            
            imageIndex += direction
        }.onChange(of: entity) { _ in
            imageIndex = 0
            direction = 1
        }
    }
}

struct ZYViewAuto: View {
    @StateObject var cpuInfo = CpuUsage()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("AutoReverse") private var autoReverse = true
    @AppStorage("SpeedProportional") private var speedProportional = true
    @AppStorage("CurrentImageSetString") private var currentImageSet: String?
    @AppStorage("PlaySpeed") private var playSpeed = 0.5
    
    @State var direction = 1
    @State var imageIndex = 0
    
    @State var width: CGFloat
    @State var height: CGFloat
    
    var entity: ZhiyinEntity? {
        get {
            let fetch_req: NSFetchRequest<ZhiyinEntity> = ZhiyinEntity.fetchRequest()
            fetch_req.predicate = NSPredicate(format: "id=%@", currentImageSet!)
            
            guard let res = try? viewContext.fetch(fetch_req) else {
                return nil
            }
            
            if res.count != 1 {
                return nil
            }
            
            return res.first!
        }
    }
    
    init(width:CGFloat, height: CGFloat ) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        
        let factor = Float(( speedProportional
                        ? 1.0001 - Double(cpuInfo.cuse)
                        : Double(cpuInfo.cuse)) / 5 * (1.1 - playSpeed))
        
        VStack {
            ZYView(
                entity: entity,
                factor: clamp(factor, lowerBound: minInterval, upperBound: .infinity),
                autoReverse: autoReverse
            )
            .frame(width: width, height: height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZYViewAuto(width: 100, height: 100).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
