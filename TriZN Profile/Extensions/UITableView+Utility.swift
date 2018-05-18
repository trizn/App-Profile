//
//  UITableView+Utility.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/25/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable {
    
}

/*
 Generic: Viet function khong quan tam den type data
 */

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        // where T: CellIdentifiable 
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T else {
            fatalError("Error dequeuing cell for identifier\(T.cellIdentifier)")
        }
        return cell
    }
}
