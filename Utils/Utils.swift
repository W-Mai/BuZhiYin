//
//  Utils.swift
//  ZhiYin
//
//  Created by W-Mai on 2023/2/18.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
        FriendLinkInfo(icon: "MenubarX", title: "MenubarX", desc: "一款强大的菜单栏浏览器", link: URL(string: "macappstore://apps.apple.com/app/apple-store/id1575588022?pt=2177920&ct=app&mt=8")!),
    ]
}

struct GifDropModifier: ViewModifier {
    @ObservedObject var 🐔: ZhiyinEntity
    
    func body(content: Content) -> some View {
        content
            .onDrop(of: [.fileURL], delegate: Delegate(🐔))
    }
    
    struct Delegate: DropDelegate {
        var 🐔: ZhiyinEntity
        
        init(_ 🐔: ZhiyinEntity) {
            self.🐔 = 🐔
        }
        
        func getURLFromInfo(info: DropInfo) -> URL? {
            if !info.hasItemsConforming(to: [.fileURL]) {
                return nil
            }
            
            guard let provider = info.itemProviders(for: [.fileURL]).first else {
                return nil
            }
            var url_ret: URL? = nil
            let sema = DispatchSemaphore(value: 0)
            debugPrint(provider)
            
            if provider.canLoadObject(ofClass: NSURL.self) {
                provider.loadObject(ofClass: NSURL.self) { (url, error) in
                    defer {
                        sema.signal()
                    }
                    
                    guard error == nil else {
                        print("Error loading item: \(error!)")
                        return
                    }
                    
                    guard let url = url as? URL else {
                        return
                    }
                    
                    url_ret = url
                }
                sema.wait()
            }
            return url_ret
        }
        
        func validateDrop(info: DropInfo) -> Bool {
            if info.hasItemsConforming(to: [.gif]) {
                debugPrint("GIF get")
                return true
            }
            
            guard let url = getURLFromInfo(info: info) else {
                return false
            }
            
            let fileType = url.pathExtension.lowercased()
            
            debugPrint("File type: \(fileType)")
            let isGif = fileType == "gif"
            
            return isGif
        }
        
        func performDrop(info: DropInfo) -> Bool {
            let providers = info.itemProviders(for: [.fileURL, .gif])
            debugPrint(providers)
            // 只要第一只🐔
            guard let provider = providers.first else {
                return false
            }
            
            if info.hasItemsConforming(to: [.gif]) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.gif.identifier) { data, error in
                    if let data = data {
                        debugPrint(data)
                        let _ = 🐔.setGIF(data: data)
                    } else if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                }
            } else if info.hasItemsConforming(to: [.fileURL]) {
                guard let url = getURLFromInfo(info: info) else {
                    return false
                }
                
                let data = try? Data(contentsOf: url)
                
                if let data = data {
                    debugPrint(data)
                    let _ = 🐔.setGIF(data: data)
                }
            }
            
            return true
        }
    }
}

func resizeImage(image: CGImage, scale: CGFloat) -> CGImage? {
    let width = Int(CGFloat(image.width) * scale)
    let height = Int(CGFloat(image.height) * scale)

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }

    context.interpolationQuality = .high
    context.draw(image, in: CGRect(origin: .zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))

    return context.makeImage()
}
