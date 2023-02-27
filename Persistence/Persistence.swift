//
//  Persistence.swift
//  ZhiYin
//
//  Created by W-Mai on 2023/2/17.
//

import Foundation
import CoreData
import AppKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "gif", subdirectory: nil) else {
            return result
        }
        
        for url in urls {
            let newItem = ZhiyinEntity(context: viewContext)
            _ = newItem.setGIF(data: (try? Data(contentsOf: url))!)
            newItem.id = UUID()
            newItem.name = "基尼钛镁\(UUID().uuidString)"
            newItem.desc = UUID().uuidString
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ZhiYins")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let description = container.persistentStoreDescriptions.first
            
            description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.tech.xclz.Zhiyin")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //  TODO: 加载其他的人的自定义包
    init(url: URL) {
        container = NSPersistentCloudKitContainer(name: "ZhiYins")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension ZhiyinEntity {
    private func getImageOptions() -> NSDictionary {
        return [kCGImageSourceShouldCache as String: NSNumber(value: true),
                kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
    }
    
    private func getCGImageSource(_ data: Data?) -> CGImageSource? {
        guard let raw_data = data else {
            return nil
        }
        
        return CGImageSourceCreateWithData(NSData(data: raw_data), getImageOptions())
    }
    
    private func getRealFrameCount(_ data: Data?) -> Int {
        guard let img_src = getCGImageSource(data) else {
            return 0
        }
        
        return CGImageSourceGetCount(img_src)
    }
    
    func setGIF(data: Data) -> Bool {
        let num = getRealFrameCount(data)
        
        if num < 0 {
            return false
        }
        
        self.frame_num = Int16(num)
        self.img_data = data
        return true
    }
    
    func getImage(_ index: Int) -> CGImage? {
        if index > self.frame_num || index < 0 {
            return nil
        }
        
        guard let img_src = getCGImageSource(self.img_data) else {
            return nil
        }
        
        return CGImageSourceCreateImageAtIndex(img_src, index, getImageOptions())
    }
}
