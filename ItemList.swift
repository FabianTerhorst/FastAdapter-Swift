//
//  ItemList.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class ItemList<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    var sections = [Section<Itm>]()
    
    var subItemCount = [Int : [Int : Int]]()
    
    public init() {
        sections.append(Section<Itm>(header: nil, items: [Itm](), footer: nil))
    }
    
    public subscript(position: Int) -> Section<Itm> {
        if sections.count <= position {
            sections.append(Section<Itm>(header: nil, items: [Itm](), footer: nil))
        }
        return sections[position]
    }
    
    public func add(section: Int = 0, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        if var sectionItems = self?[section].items {
                            sectionItems.append(item)
                            let count = sectionItems.count
                            if count > 0 {
                                listView.insertItems(at: [IndexPath(row: count - 1, section: section)])
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func add(section: Int = 0, index: Int, item: Itm) {
        let index = getExpandableOffset(index: index)
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?[section].items.insert(item, at: index)
                        listView.insertItems(at: [IndexPath(row: index, section: section)])
                    }
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, items: [Itm]) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                var arrangedItems = [Itm]()
                for item in items {
                    if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                        arrangedItems.append(item)
                    }
                }
                DispatchQueue.main.sync {
                    var indexPaths = [IndexPath]()
                    if var index = self?[section].items.count {
                        for item in arrangedItems {
                            let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                            self?[section].items.append(item)
                            indexPaths.append(IndexPath(row: index, section: section))
                            index += 1
                        }
                        listView.insertItems(at: indexPaths)
                    }
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, index: Int, items: [Itm]) {
        let index = getExpandableOffset(index: index)
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                var arrangedItems = [Itm]()
                for item in items {
                    if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                        arrangedItems.append(item)
                    }
                }
                DispatchQueue.main.sync {
                    var indexPaths = [IndexPath]()
                    var index = index
                    for item in arrangedItems {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?[section].items.insert(item, at: index)
                        indexPaths.append(IndexPath(row: index, section: section))
                        index += 1
                    }
                    listView.insertItems(at: indexPaths)
                }
            }
        }
    }
    
    public func set(section: Int = 0, items: [Itm]) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                var arrangedItems = [Itm]()
                for item in items {
                    if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                        arrangedItems.append(item)
                    }
                }
                DispatchQueue.main.sync {
                    for item in arrangedItems {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    }
                    self?[section].items = arrangedItems
                    listView.reloadSections(IndexSet(integer: section))
                }
            }
        }
    }
    
    public func update(section: Int = 0, index: Int) {
        let index = getExpandableOffset(index: index)
        if let listView = fastAdapter?.listView {
            let item = self[section].items[index]
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                    DispatchQueue.main.sync {
                        listView.reloadItems(at: [IndexPath(row: index, section: section)])
                    }
                }
            }
        }
    }
    
    public func updateAll(section: Int = 0) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            let items = self[section].items
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                for item in items {
                    let _ = self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height)
                }
                var indexPaths = [IndexPath]()
                DispatchQueue.main.sync {
                    for i in 0..<items.count {
                        indexPaths.append(IndexPath(row: i, section: section))
                    }
                    listView.reloadItems(at: indexPaths)
                }
            }
        }
    }
    
    public func set(section: Int = 0, index: Int, item: Itm) {
        let index = getExpandableOffset(index: index)
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) == true {
                    self?[section].items[index] = item
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        listView.reloadItems(at: [IndexPath(row: index, section: section)])
                    }
                }
            }
        }
    }
    
    public func remove(section: Int = 0, position: Int) {
        let position = getExpandableOffset(index: position)
        if self[section].items.count <= position {
            return
        }
        self[section].items.remove(at: position)
        if let listView = fastAdapter?.listView {
            listView.performBatchUpdates({
                listView.deleteItems(at: [IndexPath(row: position, section: section)])
            }, completion: {
                finished in
                listView.reloadSections(IndexSet(integer: section))
                //listView.reloadData()
            })
        }
    }
    
    public func setHeader(section: Int = 0, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) != nil {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?[section].header = item
                        listView.reloadSections(IndexSet(integer: section))
                    }
                }
            }
        }
    }
    
    public func setFooter(section: Int = 0, item: Itm) {
        if let listView = fastAdapter?.listView {
            let frame = listView.frame
            fastAdapter?.backgroundLayoutQueue.addOperation {
                [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame.width, height: frame.height) != nil {
                    DispatchQueue.main.sync {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?[section].footer = item
                        listView.reloadSections(IndexSet(integer: section))
                    }
                }
            }
        }
    }
    
    public func expand(section: Int = 0, index: Int) {
        let index = getExpandableOffset(index: index)
        guard let fastAdapter = fastAdapter, let listView = fastAdapter.listView else {
            return
        }
        let frame = listView.frame
        fastAdapter.backgroundLayoutQueue.addOperation {
            [weak self] in
            let item = self?.sections[section].items[index]
            guard var expandable = item as? Expandable, !expandable.expanded else {
                return
            }
            guard let fastAdapter = self?.fastAdapter else {
                return
            }
            guard let measuredSubItems = expandable.getMeasuredSubItems(measurer: fastAdapter.measurer, width: frame.width, height: frame.height), measuredSubItems.count > 0 else {
                return
            }
            expandable.expanded = true
            let measuredSubItemsCount = measuredSubItems.count
            if self?.subItemCount[section] == nil {
                self?.subItemCount[section] = [Int : Int]()
            } else {
                // Count all keys up that higher then the current index
                if let keys = self?.subItemCount.keys {
                    for key in keys {
                        if key > index {
                            if let entry = self?.subItemCount.removeValue(forKey: key) {
                                self?.subItemCount[key + measuredSubItemsCount] = entry
                            }
                        }
                    }
                }
            }
            self?.subItemCount[section]?[index] = measuredSubItemsCount
            DispatchQueue.main.sync {
                var indexPaths = [IndexPath]()
                var index = index + 1
                for item in measuredSubItems {
                    let _ = fastAdapter.typeInstanceCache.register(item: item)
                    self?[section].items.insert(item, at: index)
                    indexPaths.append(IndexPath(row: index, section: section))
                    index += 1
                }
                listView.insertItems(at: indexPaths)
            }
        }
    }
    
    public func collapse(section: Int = 0, index: Int) {
        let index = getExpandableOffset(index: index)
        if subItemCount[section]?.count ?? 0 <= section {
            return
        }
        guard let count = subItemCount[section]?[index], count > 0 else {
            return
        }
        guard let fastAdapter = fastAdapter, let listView = fastAdapter.listView else {
            return
        }
        fastAdapter.backgroundLayoutQueue.addOperation {
            [weak self] in
            let item = self?.sections[section].items[index]
            guard var expandable = item as? Expandable, expandable.expanded else {
                return
            }
            expandable.expanded = false
            // Count all keys down that are higher then the current index
            if let keys = self?.subItemCount.keys {
                for key in keys {
                    if key > index {
                        if let entry = self?.subItemCount.removeValue(forKey: key) {
                            self?.subItemCount[key - count] = entry
                        }
                    }
                }
            }
            self?.sections[section].items.removeSubrange(index + 1...index + count)
            self?.subItemCount[section]?[index] = 0
            DispatchQueue.main.sync {
                var indexPaths = [IndexPath]()
                for i in 1...count {
                    indexPaths.append(IndexPath(row: index + i, section: section))
                }
                listView.performBatchUpdates({
                    listView.deleteItems(at: indexPaths)
                }, completion: {
                    finished in
                    listView.reloadSections(IndexSet(integer: section))
                })
            }
        }
    }
    
    public func toggleExpanded(section: Int = 0, index: Int) {
        guard let expandable = sections[section].items[getExpandableOffset(section: section, index: index)] as? Expandable else {
            return
        }
        if expandable.expanded {
            collapse(section: section, index: index)
        } else {
            expand(section: section, index: index)
        }
    }
    
    private func getExpandableOffset(section: Int = 0, index: Int) -> Int {
        guard let keys = subItemCount[section]?.keys else {
            return index
        }
        var newIndex = index
        for key in keys {
            if key < index {
                newIndex += subItemCount[section]?[key] ?? 0
            }
        }
        return newIndex
    }
}

fileprivate extension Expandable {
    func getMeasuredSubItems<Itm>(measurer: Measurer<Itm>, width: CGFloat?, height: CGFloat?) -> [Itm]? {
        var measuredSubItems: [Itm]?
        if let subItems = subItems {
            for subItem in subItems {
                guard let correctTypeSubItem = subItem as? Itm else {
                    continue
                }
                if measurer.measureItem(item: correctTypeSubItem, width: width, height: height) == true {
                    if measuredSubItems == nil {
                        measuredSubItems = [Itm]()
                    }
                    measuredSubItems?.append(correctTypeSubItem)
                }
            }
        }
        return measuredSubItems
    }
}
