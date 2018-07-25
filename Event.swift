//
//  Event.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 25.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Events {
    public init() {}
}

open class Event: Events, Hashable, Equatable {
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name
    }
    
    open var name: String
    
    public convenience override init() {
        self.init(name: String(describing: type(of: self)))
    }
    
    public init(name: String) {
        self.name = name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
