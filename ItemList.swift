//
//  ItemList.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class ItemList<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    var items = [Itm]()
    
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
                if item.arrangement(width: frame.width, height: /*frame.height*/nil) != nil {
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
    
    public func add(index: Int, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if item.arrangement(width: frame.width, height: /*frame.height*/nil) != nil {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?.items.insert(item, at: index)
                        listView.insertItems(at: [IndexPath(row: index, section: 0)])
                    }
                }
            }
        }
    }
    
    public func addAll(items: [Itm]) {
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
                    var indexPaths = [IndexPath]()
                    var index = 0
                    for item in arrangedItems {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?.items.append(item)
                        indexPaths.append(IndexPath(row: index, section: 0))
                        index += 1
                    }
                    listView.insertItems(at: indexPaths)
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
    
    public func update(index: Int) {
        if let listView = fastAdapter?.listView {
            let item = items[index]
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                let _ = item.arrangement(width: frame.width, height: /*frame.height*/nil)
                DispatchQueue.main.sync {
                    listView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
    
    public func set(index: Int, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if item.arrangement(width: frame.width, height: /*frame.height*/nil) != nil {
                    self?.items[index] = item
                }
                DispatchQueue.main.sync {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    listView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
    
    public subscript(position: Int) -> Itm {
        return items[position]
    }
    
    public subscript (safe position: Int) -> Itm? {
        if items.count <= position {
            return nil
        }
        return self[position]
    }
    
    public func remove(position: Int) {
        items.remove(at: position)
        if let listView = fastAdapter?.listView {
            listView.performBatchUpdates({
                listView.deleteItems(at: [IndexPath(row: position, section: 0)])
            }, completion: {
                finished in
                listView.reloadData()
            })
        }
    }
}
