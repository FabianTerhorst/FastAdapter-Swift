//
//  ModelAdapter.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class ModelAdapter<Model, Itm: Item>: Adapter<Itm> {
    
    private let interceptor: (Model) -> (Itm?)
    
    public init(interceptor: @escaping (Model) -> (Itm?), itemList: ItemList<Itm> = ItemList<Itm>()) {
        self.interceptor = interceptor
        super.init()
        self.itemList = itemList
    }
    
    public func add(model: Model) {
        if let item = interceptor(model) {
            itemList.add(item: item)
        }
    }
    
    public func set(models: [Model]) {
        let items = models.compactMap({ interceptor($0) })
        itemList.set(items: items)
    }
}
