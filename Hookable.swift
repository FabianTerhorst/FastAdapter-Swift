//
//  Hookable.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 25.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public protocol Hookable: class {
}

public extension Hookable where Self: Item {
    func event(_ event: Event) {
        fastAdapter?.eventHooks.call(item: self, event: event)
    }
}
