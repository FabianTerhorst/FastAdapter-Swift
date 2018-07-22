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
    
    public func add(section: Int = 0, model: Model) {
        if let item = interceptor(model) {
            itemList.add(section: section, item: item)
        }
    }
    
    public func add(section: Int = 0, index: Int, model: Model) {
        if let item = interceptor(model) {
            itemList.add(section: section, index: index, item: item)
        }
    }
    
    public func addAll(section: Int = 0, models: [Model]) {
        let items = models.compactMap({ interceptor($0) })
        itemList.addAll(section: section, items: items)
    }
    
    public func set(section: Int = 0, models: [Model]) {
        let items = models.compactMap({ interceptor($0) })
        itemList.set(section: section, items: items)
    }
    
    public func set(section: Int = 0, index: Int, model: Model) {
        if let item = interceptor(model) {
            itemList.set(section: section, index: index, item: item)
        }
    }
    
    public func remove(section: Int = 0, index: Int) {
        itemList.remove(section: section, position: index)
    }
    
    public func update(section: Int = 0, index: Int) {
        itemList.update(section: section, index: index)
    }
    
    public func setHeader(section: Int = 0, model: Model) {
        if let item = interceptor(model) {
            itemList.setHeader(section: section, item: item)
        }
    }
    
    public func setFooter(section: Int = 0, model: Model) {
        if let item = interceptor(model) {
            itemList.setFooter(section: section, item: item)
        }
    }
    
    public func expanse(section: Int = 0, index: Int) {
        itemList.expand(section: section, index: index)
    }
    
    public func collapse(section: Int = 0, index: Int) {
        itemList.collapse(section: section, index: index)
    }
    
    public func getSections() -> [Section<Itm>] {
        return itemList.sections
    }
}
