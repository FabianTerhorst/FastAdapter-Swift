//
//  ModelItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class ModelItem<Model>: Item {
    public var model: Model
    
    public init(model: Model) {
        self.model = model
    }
}
