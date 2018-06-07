//
//  PhotosEntity+CoreDataClass.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/1/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//
//

import Foundation
import CoreData


public class PhotosEntity: NSManagedObject {

     let persistentContainer = NSPersistentContainer(name: "TriZN_Profile")
    
    /**
     Save [Photo] in CoreData
     - param: photos is array object Photo
     - return: no return
     */
    func saveCoreData(with photos: [Photo]) {
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
    
    /**
     Fetch [Photo] in CoreData
     - param: no param
     - return: array object [Photo]
     */
    func fetchPhotoFromCoreData(_ complitonHandler: @escaping (_ result: [Photo]?) -> Void ){
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
            
            photos = self.parsePhotoEntityToPhoto(with: results)
            complitonHandler(photos)
            
        }
        
        do {
            try privateManagedObjectContext.execute(asynchronousFetchRequest)

        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
            complitonHandler(nil)
        }
        
   
    }
    
    /**
     Check [Photo] in CoreData
     - param: no param
     - return: array [Photo]
     */
    func checkPhotoInCoreData(with photos: [Photo]) {
        
        //Fetch core data -> array object Photo
        var photosCoreData = [Photo]()
        fetchPhotoFromCoreData { (result) in
            if let result = result {
             photosCoreData = result
            }
            
            if photosCoreData.isEmpty {
                // Save coredata first setup app
                self.saveCoreData(with: photos)
            } else {
            
                for photo in photos {
                    if photosCoreData.contains(where: { $0.id == photo.id}) {
                        
                    } else if !photosCoreData.isEmpty {
                        self.saveCoreData(with: [photo])
                    }
                    
                }
            }
        }
  
    }
    
    /**
     Parse PhotoEntity to Photo
     - param: @data is array [NSManagedObject]
     - return: array [Photo]
     */
    
    func parsePhotoEntityToPhoto(with data: [PhotosEntity]) -> [Photo] {
        var photos = [Photo]()
        for item in data {
            if let photo = Photo.init(withNSManagedObject: item) {
                photos.append(photo)
            }
        }
        
        return photos
    }
}
