//
//  AbstractModelLayoutItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 19.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class AbstractModelLayoutItem: LayoutItem {
    public var _model: Any
    
    init(model: Any) {
        self._model = model
    }
}
