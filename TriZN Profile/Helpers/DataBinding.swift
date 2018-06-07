//
//  DataBinding.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/28/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation

class DataBinding<T> {
    typealias Handler = (T) -> Void
    private var handler: [Handler] = []
    
    var value: T {
        didSet {
            self.fire()
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(hdl: @escaping Handler) {
        self.handler.append(hdl)
    }
    
    func bindAndFie(hdl: @escaping Handler) {
        self.bind(hdl: hdl)
        self.fire()
    }
    
    private func fire() {
        for hdl in handler {
            hdl(value)
        }
    }
}
