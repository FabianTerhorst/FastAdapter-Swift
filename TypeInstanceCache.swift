//
//  TypeInstanceCache.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class TypeInstanceCache<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    var typeInstances = [String: Itm]()
    
    init(fastAdapter: FastAdapter<Itm>) {
        self.fastAdapter = fastAdapter
    }
    
    func register(item: Itm) -> Bool {
        let typeId = item.getType()
        if typeInstances.index(forKey: typeId) == nil {
            typeInstances[typeId] = item
            _register(typeId: typeId, item: item)
            return true
        }
        return false
    }
    
    private func _register(typeId: String, item: Itm) {
        if let listView = fastAdapter?.listView {
            listView.register(item.getCell(), forCellWithReuseIdentifier: typeId)
        }
    }
    
    func get(typeId: String) -> Item? {
        return typeInstances[typeId]
    }
    
    func clear() {
        typeInstances.removeAll()
    }
    
    func renew() {
        for (typeId, item) in typeInstances {
            _register(typeId: typeId, item: item)
        }
    }
}
