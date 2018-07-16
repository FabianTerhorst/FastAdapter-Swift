//
//  IModelItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 13.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class AbstractModelItem: Item {
    public var _model: Any
    
    init(model: Any) {
        self._model = model
    }
}
