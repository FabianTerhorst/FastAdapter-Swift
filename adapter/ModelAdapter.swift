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
    
    public func add(index: Int, model: Model) {
        if let item = interceptor(model) {
            itemList.add(index: index, item: item)
        }
    }
    
    public func set(models: [Model]) {
        let items = models.compactMap({ interceptor($0) })
        itemList.set(items: items)
    }
    
    public func set(index: Int, model: Model) {
        if let item = interceptor(model) {
            itemList.set(index: index, item: item)
        }
    }
    
    public func remove(index: Int) {
        itemList.remove(position: index)
    }
    
    public func update(index: Int) {
        itemList.update(index: index)
    }
    
    public func getItems() -> [Itm] {
        return itemList.items
    }
}
