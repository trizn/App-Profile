//
//  PaginationHelper.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/15/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation

protocol Keyed {
    var key: String? { get set}
}

class PaginationHelper<T: Keyed> {
    enum PaginationState {
        case initial
        case ready
        case loading
        case end
    }
    
    // MARK: - Properties
    let pageSize: UInt
    let serviceMethod: (UInt, String?, @escaping(([T]) -> Void)) -> Void
    var state: PaginationState = .initial
    var lastKeyID: String?
    
    // MARK: Init
    init(pageSize: UInt = 3, serviceMethod: @escaping(UInt, String?, @escaping(([T]) -> Void)) -> Void) {
        self.pageSize = pageSize
        self.serviceMethod = serviceMethod
    }
    
    // MARK: - Methods
    func paginate(completion: @escaping([T]) -> Void) {
        switch state {
        case .initial:
            lastKeyID = nil
            fallthrough
        case .ready:
            state = .loading
            serviceMethod(pageSize, lastKeyID, { (objects: [T]) in
                defer {
                    if let lastKeyID = objects.last?.key {
                        self.lastKeyID = lastKeyID
                    }
                    
                    self.state = objects.count < Int(self.pageSize) ? .end : .ready
                }
                
                guard let _ = self.lastKeyID else {
                    return completion(objects)
                }
                
                let newObjects = Array(objects.dropFirst())
                completion(newObjects)
            })
        case .loading, .end:
            return
        }
    }
    
    func reloadData(completion: @escaping([T]) -> Void ) {
        state = .initial
        paginate(completion: completion)
    }
}
