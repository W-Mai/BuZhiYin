//
//  Persistence.swift
//  BuZhiYin
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
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

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
    
    static func 👈Default🐔📃() -> [String : (String, Bool, Bool, String)] {
        return [
            "mongmong":             ("CA7AC4E7-3064-41C7-9D82-C2FDB5740217", false, false, "mongmong🐰"),
            "cat":                  ("CF24D359-0583-4090-A8A0-E29C9AB70F7C", false, false, "猫砸键盘🐱"),
            "gojo_satoru":          ("05546D59-C6D8-4A5D-B962-232D1524168E", false, false, "五条梧🥷"),
            "pink_cat":             ("B4328AC3-5877-42A3-B968-50E85DB3C94A", false, false, "粉色猫猫🐱"),
            "zhiyin_basketball":    ("C886E4B9-101C-419D-A7C6-1DC574C56415", false, true,  "只因篮球🏀"),
            "big_mouse_frog":       ("65009A78-3099-4AD0-9F61-2AFD755E40BD", false, false, "大嘴🐸"),
            "xiaolan_turn":         ("760F7EF7-86AE-4D09-91F0-9A4F29B6DC32", false, false, "小蓝转圈圈♿️" ),
            "karby":                ("D7DF9595-F3FC-4A4F-A134-8F9CED4B761D", false, false, "星之卡比"),
            "txbb":                 ("076C5D49-7F6B-440B-AEC5-A95DF934B8DA", false, false, "天线宝宝👶"),
            "zhiyin":               ("EF2FA09B-20C4-4078-84AD-6879DF5D2DC5", false, true,  "只因铁山靠⛰️"),
            "3body":                ("0DC947AB-0D3F-4E6B-9CD1-F457DFF94AA3", false, false, "金凯瑞摇🤘"),
            "baby_circle":          ("3D875F2D-3C0D-4893-BB88-D04DE9950044", false, false, "可爱小圈圈😲"),
            "cat2":                 ("998E352C-579D-4D1D-9D53-71B2FA96A297", false, false, "猫砸键盘盘😼"),
            "cat3":                 ("8A55997C-CC7A-4A99-8F75-534FC8FB5FB8", false, false, "猫猫摇爪😺"),
            "color_worm":           ("82078124-8DCE-4952-AAB5-7C97D3EBC8A3", false, false, "🌈🐛"),
            "everonecat0":          ("7DA8BD6D-48EF-4EEB-84D5-B1DB5ECCC136", false, false, "EveroneCat"),
            "hoshiguma":            ("B668833C-F001-450B-BC19-1A3CF00FAB6E", false, false, "星熊警官🛡️"),
            "jerry":                ("1E027273-96EE-4C60-A942-A8CD8207DDBD", false, false, "Jerry🐭"),
            "my0":                  ("41E63F23-2325-4586-AD9D-5D86D633BB5F", false, false, "BenignX"),
        ]
    }
    
    static func fillWithDefault🐔(context: NSManagedObjectContext) -> Int {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "gif", subdirectory: nil) else {
            return 0
        }
        
        let default📃 = 👈Default🐔📃()
        
        var count = 0
        for url in urls {
            let name = url.deletingPathExtension().lastPathComponent
            guard let conf = default📃[name] else {
                continue
            }
            
            let _ = create🆕🐔(context: context,
                                    data: (try? Data(contentsOf: url))!,
                                    id: UUID(uuidString: conf.0)!,
                                    name: conf.3,
                                    desc: "不只因默认只因",
                                    light_invert: conf.1,
                                    dark_invert:  conf.2)
            count += 1
        }
        
        return count
    }
    
    static func cleanWithDefault🐔(context: NSManagedObjectContext) -> Bool {
        let rq: NSFetchRequest<NSFetchRequestResult> = ZhiyinEntity.fetchRequest()
        rq.predicate = NSPredicate(format: "id IN %@", 👈Default🐔📃().flatMap({ (key: String, value: (String, Bool, Bool, String)) in
            return [value.0]
        }))
        
        guard let res = try? context.fetch(rq) else {
            fatalError("🐔窝出现了问题")
        }
        
        res.forEach { 🐔 in
            context.delete(🐔 as! ZhiyinEntity)
        }
        
        return true;
    }
    
    static func hasDefault🐔(context: NSManagedObjectContext) -> Bool {
        let rq: NSFetchRequest<NSFetchRequestResult> = ZhiyinEntity.fetchRequest()
        rq.predicate = NSPredicate(format: "id IN %@", 👈Default🐔📃().flatMap({ (key: String, value: (String, Bool, Bool, String)) in
            return [value.0]
        }))
        
        guard let res = try? context.fetch(rq) else {
            fatalError("🐔窝出现了问题")
        }
        
        return res.count != 0
    }
    
    static func create🆕🐔(context: NSManagedObjectContext, data: Data, id: UUID, name: String, desc: String, light_invert: Bool, dark_invert: Bool) -> ZhiyinEntity {
        let rq = ZhiyinEntity.fetchRequest()
        rq.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        guard let res = try? context.fetch(rq) else {
            fatalError("🐔窝出现了问题")
        }
        
        if !res.isEmpty {
            return res.first!
        }
        
        let 🆕🐔 = ZhiyinEntity(context: context)
        _ = 🆕🐔.setGIF(data: data)
        🆕🐔.id = id
        🆕🐔.name = name
        🆕🐔.desc = desc
        🆕🐔.light_invert = light_invert
        🆕🐔.dark_invert = dark_invert
        return 🆕🐔
    }
    
    static func createDefault🐔(context: NSManagedObjectContext) -> ZhiyinEntity {
        guard let url = Bundle.main.url(forResource: "add_zhiyin", withExtension: "gif") else {
            fatalError("Lost Resources")
        }
        return create🆕🐔(context: context,
                               data: (try? Data(contentsOf: url))!,
                               id: UUID(),
                               name: "只因",
                               desc: "新只因",
                               light_invert: false,
                               dark_invert: true)
    }
    
    static func save(context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension ZhiyinEntity {
    static var defaultImage = #imageLiteral(resourceName: "ZhiyinDefault").cgImage(forProposedRect: nil, context: nil, hints: nil)!
    
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
    
    func getImage(_ index: Int) -> CGImage {
        var index = index
        if index >= self.frame_num || index < 0 {
            index = 0
        }
        
        guard let img_src = getCGImageSource(self.img_data) else {
            return ZhiyinEntity.defaultImage
        }
        
        return CGImageSourceCreateImageAtIndex(img_src, index, getImageOptions()) ?? ZhiyinEntity.defaultImage
    }
}
