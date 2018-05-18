//
//  PhotoServices.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/10/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import Toast_Swift

class PhotoServices: NSObject {

    // MARK: - Properties
    
    
    // Return array of image URLs from Flichkr
    class func peopleGetPhotos(viewController: UIViewController , page: Int = 1, completionHandler: @escaping (_ photos: [String: Any]?, _ photoURLs: [Photo?]?, _ error: NSError?)->Void) {
        var photoURLs = [Photo?]()
        
        // Get data from CoreData
        var photosCoreData: [Photo] = []
        
        let flickrPeopleGetPhotos = FKFlickrPeopleGetPhotos()
        flickrPeopleGetPhotos.user_id = User.share().userId
        flickrPeopleGetPhotos.per_page = "18"
        flickrPeopleGetPhotos.page = String(page)

        FlickrKit.shared().call(flickrPeopleGetPhotos, completion: { (response, error) in
            DispatchQueue.main.async(execute: {
                if let response = response,
                    let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    
                    guard let photos = response["photos"] as? [String : Any] else {
                        return
                    }
                    
                    for photoDictionary in photoArray {
    
                        let photo = Photo(with: photoDictionary)
                        photoURLs.append(photo)

                    
                    }
                    
                    // Threard run background get info photo , after save in CoreData
                    DispatchQueue.global(qos: .background).async {
                        PhotoServices.getInfo(with: photoURLs as! [Photo]) { (photosInfo, error) in
                            if error == nil {
                                // Save CoreData
                                let check = PhotosEntity()
                                check.checkPhotoInCoreData(with: photosInfo)
                            
                            } else {
                                fatalError("Error write in Core Data \(String(describing: error?.description))")
                            }
                            
                        }
                    }
                    // Save gallery to CoreData
//                    Photo.saveCoreData(with: photoArray)
                    
                    completionHandler(photos, photoURLs, nil)
                } else {
                    if let error = error as NSError? {
                        
                        // If no conection internet, get data from CoreData
                        if error.code == 200 {
                            let coreData = PhotosEntity()
                            coreData.fetchPhotoFromCoreData { result in
                                if let result = result {
                                    completionHandler(nil, result, error)
                                    
                                }
                            }
//                            for photo in photosCoreData {
//                                photoURLs.append(photo)
//                            }
//
                        }
                    
                        // Show error
                        viewController.view.makeToast("\(error.localizedDescription)")
                        
                        //
//                        completionHandler(nil, photoURLs, error)
                    }
                }
            })
        })
        
    }
    
    
    // Get info date upload
    class func getInfo(with photos: [Photo], complitionHandle: @escaping (_ photosInfo: [Photo] , _ error: NSError?) -> Void) {
        
        var _photosInfo = [Photo] ()
        
        let group = DispatchGroup()
        
        for photo in photos {
            group.enter()
            if let id = photo.id {
    //            flickr.photos.getInfo
                let flickrGetInfo = FKFlickrPhotosGetInfo()
                flickrGetInfo.photo_id = id
                
                FlickrKit.shared().call(flickrGetInfo, completion: { (response, error) in
                        if  let response = response {
                            let data = response["photo"] as? [String : Any]
                            let dateTimestampString = (data!["dateuploaded"] as? String)
                            
                            let dateDouble = NumberFormatter().number(from: dateTimestampString!)?.doubleValue
                            let date = NSDate(timeIntervalSince1970: dateDouble!)
                            
                            photo.dateUpload = date
                            _photosInfo.append(photo)
                        }
                    group.leave()
                })
                
            }
        }
        
        group.notify(queue: .global(qos: .background), execute: {
            complitionHandle(_photosInfo, nil)
        })
        
        
    }

}
