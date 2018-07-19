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
                if self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height) != nil {
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
                if self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height) != nil {
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
                    if self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height) != nil {
                        arrangedItems.append(item)
                    }
                }
                DispatchQueue.main.sync {
                    var indexPaths = [IndexPath]()
                    var index = self?.items.count ?? 0
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
                    if self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height) != nil {
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
                [weak self] in
                let _ = self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height)
                DispatchQueue.main.sync {
                    listView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
    
    public func updateAll() {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            let items = self.items
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                for item in items {
                    let _ = self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height)
                }
                var indexPaths = [IndexPath]()
                DispatchQueue.main.sync {
                    for i in 0..<items.count {
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    listView.reloadItems(at: indexPaths)
                }
            }
        }
    }
    
    public func set(index: Int, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.arranger.arrangeItem(item: item, width: frame.width, height: frame.height) != nil {
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
        if items.count <= position {
            return
        }
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
