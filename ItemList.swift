//
//  ItemList.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class ItemList<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    private var items = [Itm]()
    
    public var count: Int {
        get {
            return items.count
        }
    }
    
    public init() {
        
    }
    
    public func add(item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if item.arrangement(width: frame.width, height: frame.height) != nil {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?.items.append(item)
                        if let count = self?.items.count, count > 0 {
                            listView.insertItems(at: [IndexPath(row: count - 1, section: 0)])
                        }
                    }
                }
            }
        }
    }
    
    public func set(items: [Itm]) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                var arrangedItems = [Itm]()
                for item in items {
                    if item.arrangement(width: frame.width, height: /*frame.height*/nil) != nil {
                        arrangedItems.append(item)
                    }
                }
                DispatchQueue.main.sync {
                    for item in arrangedItems {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    }
                    self?.items = arrangedItems
                    listView.reloadData()
                }
            }
        }
    }
    
    public func set(index: Int, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if item.arrangement(width: frame.width, height: frame.height) != nil {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    self?.items[index] = item
                }
                DispatchQueue.main.sync {
                    listView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
    
    public func get(position: Int) -> Itm {
        return items[position]
    }
    
    public func remove(position: Int) {
        items.remove(at: position)
    }
}
