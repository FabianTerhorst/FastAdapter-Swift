//
//  ModelLayoutItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 19.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class ModelLayoutItem<Model>: AbstractModelLayoutItem {
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
