//
//  PhotosEntity+CoreDataProperties.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/1/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotosEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotosEntity> {
        return NSFetchRequest<PhotosEntity>(entityName: "PhotosEntity")
    }

    @NSManaged public var dateUpload: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var secret: String?
    @NSManaged public var title: String?

    
    

}
