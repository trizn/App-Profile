//
//  Photo.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/22/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation
import FlickrKit
import CoreData

class Photo: NSObject {
    var id: String?
    var secret: String?
    var title: String?
    var imageURL: URL?
    var dateUpload: NSDate?
    
    init(with dictionary: [String: Any]?) {
        if let dictionary = dictionary {
            self.id = dictionary["id"] as? String ?? ""
            self.secret = dictionary["secret"] as? String ?? ""
            self.title = dictionary["title"] as? String ?? ""
            self.imageURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small320, fromPhotoDictionary: dictionary)
            
        }
        
    }
    
    init?(withNSManagedObject: PhotosEntity ) {
        self.id = withNSManagedObject.id
        self.secret = withNSManagedObject.secret
        self.title = withNSManagedObject.secret
        self.imageURL = withNSManagedObject.imageURL
        self.dateUpload = withNSManagedObject.dateUpload
    }
    
    
    // Save response in CoreData
    class func saveCoreData(with photos: [Photo]) {
        
//        let fetchData = self.fetchCoreData() ?? []

        /*
//        for photo in photos.reversed() {
////
////            let photo = Photo(with: dictionary)
////
////            // If data from coredata, have id = photo fetch
//            if fetchData.contains(where: { $0.id == photo.id}) {
//
//            } else if !fetchData.isEmpty {
////
////                    self.addEntryToCoreData(withPhoto: photo)
//
//            }
//             if fetchData.isEmpty { // Write coredata fist app.
//                self.addEntryToCoreData(withPhoto: photo)
//            }
//        }
            */
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
        
        let persistentContainer = NSPersistentContainer(name: "TriZN_Profile")
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failure to load Core Data stack: \(error)")
            }
        })
        persistentContainer.performBackgroundTask { (context) in
            photos.forEach { photo in
                let entry = PhotosEntity(context: context)
            entry.id = photo.id
            entry.dateUpload = photo.dateUpload
            entry.imageURL = photo.imageURL
            entry.title = photo.title
            entry.secret = photo.secret
            }
            
            do {
                // Save the entries created in the 'forEarch'
                try context.save()
            } catch {
                fatalError("Failure to save context \(context)")
            }
        }
 
    }
    
    /*
     Read data from CoreData
     - return: array [Photo]
    **/
    
    class func fetchCoreData() -> [Photo] {
        
        let persistentContainer = NSPersistentContainer(name: "TriZN_Profile")
        
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failure to load Core Data stack: \(error)")
            }
        })
        
        let privateManagedObjectContext = persistentContainer.newBackgroundContext()
        
        // Creates a Fetch request to get all the Photos saved
        let fetchRequest = NSFetchRequest<PhotosEntity>(entityName: "PhotosEntity")
        
        var photos = [Photo]()
        
        // Creates asynchronounsFetchRequest with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            guard let  results = asynchronousFetchResult.finalResult else { return }
            
            for result in results {
                if let photo = Photo(withNSManagedObject: result) {
                    photos.append(photo)
                }
            
            }
            
        }
        
        do {
            try privateManagedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
        
        return photos
    }
    
//    class func updateInfoPhoto() {
//        let persistentContainer = NSPersistentContainer(name: "TriZN_Profile")
//        
//        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
//            if let error = error {
//                fatalError("Failure to load Core Data stack: \(error)")
//            }
//        })
//        
//        
//        persistentContainer.performBackgroundTask { privateManagedObjectContext in
//            guard let queueSafePhoto = privateManagedObjectContext.object(with: <#T##NSManagedObjectID#>)
//            
//        }
//    }
    
     class func addEntryToCoreData(withPhoto: Photo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let persistentContainer = NSPersistentContainer.init(name: "PhotosEntity")
        persistentContainer.performBackgroundTask { (context) in
            
        }
        
        let contex = appDelegate.persistentContainer.viewContext
//        let newEntry = PhotosEntity(context: contex)
//
//        newEntry.id = withPhoto.id
//        newEntry.title = withPhoto.title
//        newEntry.secret = withPhoto.secret
//        newEntry.imageURL = withPhoto.imageURL
//        newEntry.dateUpload = withPhoto.dateUpload
//
//        appDelegate.saveContext()
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = contex.persistentStoreCoordinator
        privateContext.perform {
            let contex = appDelegate.persistentContainer.viewContext
            let newEntry = PhotosEntity(context: contex)
            
            newEntry.id = withPhoto.id
            newEntry.title = withPhoto.title
            newEntry.secret = withPhoto.secret
            newEntry.imageURL = withPhoto.imageURL
            newEntry.dateUpload = withPhoto.dateUpload
    
            
            appDelegate.saveContext()
        }
    }
    
    class func deleteAllDataInCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let contex = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoEntity")
        let dellAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try contex.execute(dellAllRequest)
        } catch  {
            print(error)
        }
        
    }
    
}
