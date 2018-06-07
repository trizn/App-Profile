//
//  GalleryViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/4/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import FlickrKit
import Toast_Swift

class GalleryViewController: UIViewController {

    // MARK: - Properties
    var helperFlick = FlickrHelper()
    private var _photos: [Photo?]?
    var selectedCell: Int!
    let refreshControl = UIRefreshControl()
    private var _totalPhotos: Int?
    private var _pageCurrent: Int = 1
    private var _pages: Int?
    private var _isRefresh: Bool = false
    private var _imagePicker : UIImage?
    private var _isLogin: Bool = false
    
    // Properties Core Data
    private var _photoCoreData: [NSManagedObject] = []
    
    // Properties ImagePickerController
    fileprivate let imagePickerController = UIImagePickerController()
    
    // Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        _photos = [Photo]()
        
        // Pull down Refresher
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        
        // Register Cell
        collectionView.register(UINib(nibName: "GalleryCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")

        
        // UIImagePicker: set delegate
        imagePickerController.delegate = self
        
        if let name = UserModel.share().name {
            navigationItem.title = "Welcome \(name)"
        }
        
        // Fetch images from Flickr
        fetchImages()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true

        // Show item logout in navagation when user authented
        DispatchQueue.main.async(execute: {
            if UserModel.share().accessToken != nil {
                self.configureNavigationItem()
            }
            
        })
    }
    
    // MARK: - Private function
    private func configureNavigationItem() {
        
        // Add a item in navigation
        if UserModel.share().accessToken != nil {
            
            let rightButtonItem = UIBarButtonItem(image: UIImage(named: "icon_logout.png"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(self.logOut(sender:))
                
            )
            
            let leftButtonItem = UIBarButtonItem(image: UIImage(named: "icon_gallery.png"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(self.loadGalleryInDevice(_:)))
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButtonItem
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButtonItem
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Gallery_ImagePreview":
            if let destination = segue.destination as? ImagePreviewViewController {
                destination.getURL = self._photos?[selectedCell]
            }
        default:
            break
        }
    }
    
    
    // Fetches images from Photostreams through Model Object
    @objc func fetchImages(withPage page: Int = 1) {
        
        PhotoServices.peopleGetPhotos(viewController: self, page: page, completionHandler: { (photos, urls, error) in
            if error == nil {
                
                self._totalPhotos = Int(photos!["total"] as? String ?? "") ?? 0
                if let pages = photos!["pages"] as? Int {
                    self._pages = pages
                }
                
                guard let URLs = urls else {
                    return
                }

                if self._isRefresh {
                    self._photos?.removeAll()
                    self._pageCurrent = 1
                    self._isRefresh = false
                }
                
                for url in URLs {
                    self._photos?.append(url)

                }
                
                self.collectionView.reloadData()
 
                self.refreshControl.endRefreshing()
                
            } else {
                
                DispatchQueue.global(qos: .background).async {
                    // Response from CoreData
                    guard let URLs = urls else {
                        return
                    }
                    
                    for url in URLs {
                        if (self._photos?.contains(url))! {
                            
                        } else {
                            self._photos?.append(url)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        // Show error
                        self.view.makeToast("\(String(describing: error!.localizedDescription))")
                    }
                    
                }
                
                
            }
        })
    }
    
    @objc func pullToRefresh() {
        _isRefresh = true
        self.fetchImages()
        refreshControl.endRefreshing()
    }
    
    /**
    * Log out account Flickr
     * @param: sender UIBarButtonItem
     * @return: no retunr
    */
    @objc func logOut(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure, you want to Logout", preferredStyle: .alert)
        let noButton = UIAlertAction.init(title: "No", style: .default, handler: nil)
        let yesButton = UIAlertAction.init(title: "Yes", style: .destructive, handler: { (action) in
            if (FlickrKit.shared().isAuthorized) {
                FlickrKit.shared().logout()
                
                UserModel.destroy()
                
                self.popToLoginViewController()
            }
        })
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
        

    }
    
    /**
     * Upload photo at Flickr
     * @param: sender UIBarButtonItem
     * @return: no retunr
     */
    func uploadOnFlick(sender: UIBarButtonItem) {
        
    }
    
    func popToLoginViewController() {
        let storyboad = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboad.instantiateViewController(withIdentifier: "IdentifyLoginViewController")
        self.navigationController?.setViewControllers([loginVC], animated: true)
        
        navigationController?.popToViewController(loginVC, animated: true)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as! GalleryCell
        cell.photoURL = self._photos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard  let photo = self._photos else {
            return 0
        }
        
        return photo.count
    }
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        self.performSegue(withIdentifier: "Gallery_ImagePreview", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoURLs = _photos else {
            return
        }
        
        if indexPath.row >= photoURLs.count - 4,
            let _pages = _pages,
            _pageCurrent < _pages {
            _pageCurrent += 1
            fetchImages(withPage: _pageCurrent)
        }
    }
    
    // MARK: - Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3
        return CGSize.init(width: width - 1, height: width - 1)
    }
}


// Extension: UIImagePickerControllerDelegate
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     * Open gallery photo on device.
     * @param: sender UIBarButtonItem
     * @return: no retunr
     */
    @objc func loadGalleryInDevice(_ sender: UIBarButtonItem) {
//
//        imagePickerController
        imagePickerController.sourceType = .photoLibrary
        
        // Configure imagePicker
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.tintColor = UIColor.blue
        imagePickerController.navigationBar.backgroundColor = UIColor.clear
        
        // Present imagePickerViewController
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            _imagePicker = pickerImage

            let vc = storyboard?.instantiateViewController(withIdentifier: "Preview") as? ImagePreviewViewController
            vc?.modalPresentationStyle = .overCurrentContext
            
            vc?.image = _imagePicker
            picker.navigationBar.isTranslucent = false
            picker.navigationBar.tintColor = UIColor.blue
            
            
            picker.pushViewController(vc!, animated: true)
        }
    }
    
    
}

