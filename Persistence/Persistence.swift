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
    static let shared : PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        let fq = ZhiyinEntity.fetchRequest()
        
        guard let count = try? viewContext.count(for: fq) else {
            return result
        }
        
        if count == 0 {
            _ = fillDefaultContent(context: viewContext)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        _ = fillDefaultContent(context: viewContext)
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
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
//        let persistentStoreDescription = NSPersistentStoreDescription(url: storeURL)
//        persistentStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
//        persistentStoreDescription.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
//        persistentStoreDescription.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
//
//        let container = NSPersistentContainer(name: "MyModel")
//        container.persistentStoreDescriptions = [persistentStoreDescription]
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error {
//                // 处理错误
//            }
//        }

        container = NSPersistentContainer(name: "ZhiYins")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let description = container.persistentStoreDescriptions.first
            description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
//            description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.tech.xclz.Zhiyin")
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
//        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
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
    
    static func fillDefaultContent(context: NSManagedObjectContext) -> Int {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "gif", subdirectory: nil) else {
            return 0
        }
        let defaultConf = [
            "mongmong": ("mongmong🐰", false, false),
            "cat": ("猫砸键盘🐱", false, false),
            "gojo_satoru": ("五条梧🥷", false, false),
            "pink_cat": ("粉色猫猫🐱", false, false),
            "zhiyin_basketball": ("只因篮球🏀", false, true),
            "big_mouse_frog": ("大嘴🐸", false, false),
            "xiaolan_turn": ("小蓝转圈圈♿️", false, false),
            "karby": ("星之卡比", false, false),
            "txbb": ("天线宝宝👶", false, false),
            "zhiyin": ("只因铁山靠⛰️", false, true)
        ]
        
        var count = 0
        for url in urls {
            let name = url.deletingPathExtension().lastPathComponent
            guard let conf = defaultConf[name] else {
                continue
            }
            
            let newItem = ZhiyinEntity(context: context)
            _ = newItem.setGIF(data: (try? Data(contentsOf: url))!)
            newItem.id = UUID()
            newItem.name = conf.0
            newItem.desc = "不只因默认只因"
            newItem.light_invert = conf.1
            newItem.dark_invert = conf.2
            count += 1
        }
        
        return count
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
        var index = index
        if index > self.frame_num || index < 0 {
            index = 0
        }
        
        guard let img_src = getCGImageSource(self.img_data) else {
            return nil
        }
        
        return CGImageSourceCreateImageAtIndex(img_src, index, getImageOptions())
    }
}
