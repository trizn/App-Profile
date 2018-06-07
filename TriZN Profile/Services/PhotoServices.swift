//
//  PhotoServices.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/10/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import Toast_Swift

class PhotoServices {
    // MARK: Properties
    var completeAuthOp: FKDUNetworkOperation!
    var checkAuthOp: FKDUNetworkOperation!
    
    /*
     1. Begin Authorization, onSuccess display authURL in a UIWebView - the url is a callback into your app with a URL scheme
     - return: urlRequest
     **/
    func auth() -> URLRequest? {
        var urlRequest: URLRequest?
        let callbackURLString = "triznprofile://auth"
        
        let semaphore = DispatchSemaphore(value: 0)
            
        if let url = URL(string: callbackURLString) {
            FlickrKit.shared().beginAuth(withCallbackURL: url, permission: FKPermission.delete, completion: { (url, error) -> Void in

                    if error == nil {
                        let request = NSMutableURLRequest(url: url!,
                                                          cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy,
                                                          timeoutInterval: 30) as URLRequest
                        urlRequest = request
                        // semaphore done
                        semaphore.signal()
                    }
            })
        }
        // semaphore wait before return authURL
        semaphore.wait()
        
        return urlRequest
    }

    
    // 2. After they login and authorize the app, need to get an auth token - this will happen via your URL scheme - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    func checkAuthentication(callbackURL: URL, response: @escaping (Error?) -> Void) {
        self.completeAuthOp = FlickrKit.shared().completeAuth(with: callbackURL, completion: {
            (userName, userID, fullName, error) -> Void in
            DispatchQueue.main.sync(execute: { () -> Void in
                if error == nil {
                    UserModel.share().setProfileInfo(userName: userName, fullName: fullName, userId: userID)
                    response(nil)
                } else {
                    guard let message = error?.localizedDescription else {
                        return
                    }
                    // HelperAlert.showAlert(sender: sender, title: "Sorry", message: message)
//                    sender.view.makeToast(message)
                    response(error)
                }
            })
        })
    }

    // 3. On returning to the app, you want to re-log them in automatically - do it here
    func reLogin(sender: UIViewController, _ completionHandle: @escaping (_ error: Error?) -> Void) {
        self.checkAuthOp = FlickrKit.shared().checkAuthorization {
            (userName, userID, fullName, error) in
            if error == nil {
                UserModel.share().setProfileInfo(userName: userName, fullName: fullName, userId: userID)
                
                completionHandle(nil)
                
            } else {
                guard let message = error?.localizedDescription else {
                    return
                }
                
                if message.contains("There isn't a stored token to check. Login first.") {
                    UserModel.userDefaults.removeObject(forKey: UserModel.tokenKey)
                }
                
                completionHandle(error)
                
            }
        }
    }
    
    
    // Return array of image URLs from Flichkr
    class func peopleGetPhotos(viewController: UIViewController , page: Int = 1, completionHandler: @escaping (_ photos: [String: Any]?, _ photoURLs: [Photo?]?, _ error: NSError?)->Void) {
        var photoURLs = [Photo?]()
        
        let flickrPeopleGetPhotos = FKFlickrPeopleGetPhotos()
        flickrPeopleGetPhotos.user_id = UserModel.share().userId
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
                    
                    // Thread run background get info photo , after save in CoreData
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
                        }
                    
                        // Show error
                        viewController.view.makeToast("\(error.localizedDescription)")

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
