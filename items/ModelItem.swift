//
//  ModelItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class ModelItem<Model>: AbstractModelItem {
    public var model: Model {
        get {
            return _model as! Model
        }
        set {
            _model = newValue
        }
    }
    
    public init(model: Model) {
        super.init(model: model)
    }
}
