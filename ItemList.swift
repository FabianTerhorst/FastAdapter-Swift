//
//  ItemList.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class ItemList<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    public var sections = [Section<Itm>]()
    
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
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    self?[section].items.append(item)
                    if let count = self?[section].items.count, count > 0  {
                        self?.fastAdapter?.notifier.insertItems(at: [IndexPath(row: count - 1, section: section)])
                    }
                }
            }
        }
    }
    
    public func add(section: Int = 0, index: Int, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    self?[section].items.insert(item, at: index)
                    self?.fastAdapter?.notifier.insertItems(at: [IndexPath(row: index, section: section)])
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            var arrangedItems = [Itm]()
            for item in items {
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                    arrangedItems.append(item)
                }
            }
            ItemList<Itm>.main {
                var indexPaths = [IndexPath]()
                if var index = self?[section].items.count {
                    for item in arrangedItems {
                        let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                        self?[section].items.append(item)
                        indexPaths.append(IndexPath(row: index, section: section))
                        index += 1
                    }
                    self?.fastAdapter?.notifier.insertItems(at: indexPaths)
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, index: Int, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            var arrangedItems = [Itm]()
            for item in items {
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                    arrangedItems.append(item)
                }
            }
            ItemList<Itm>.main {
                var indexPaths = [IndexPath]()
                var index = index
                for item in arrangedItems {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    self?[section].items.insert(item, at: index)
                    indexPaths.append(IndexPath(row: index, section: section))
                    index += 1
                }
                self?.fastAdapter?.notifier.insertItems(at: indexPaths)
            }
        }
    }
    
    open func set(section: Int = 0, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            var arrangedItems = [Itm]()
            for item in items {
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                    arrangedItems.append(item)
                }
            }
            ItemList<Itm>.main {
                for item in arrangedItems {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                }
                self?[section].items = arrangedItems
                self?.fastAdapter?.notifier.reloadSection(section: section)
            }
        }
    }
    
    public func update(section: Int = 0, index: Int) {
        let item = self[section].items[index]
        let frame = getFrame()
        addOperation {
            [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    self?.fastAdapter?.notifier.reloadItems(at: [IndexPath(row: index, section: section)])
                }
            }
        }
    }
    
    public func updateAll(section: Int = 0) {
        let frame = getFrame()
        let items = self[section].items
        addOperation {
            [weak self] in
            for item in items {
                let _ = self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height)
            }
            var indexPaths = [IndexPath]()
            ItemList<Itm>.main {
                for i in 0..<items.count {
                    indexPaths.append(IndexPath(row: i, section: section))
                }
                self?.fastAdapter?.notifier.reloadItems(at: indexPaths)
            }
        }
    }
    
    public func set(section: Int = 0, index: Int, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                self?[section].items[index] = item
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    self?.fastAdapter?.notifier.reloadItems(at: [IndexPath(row: index, section: section)])
                }
            }
        }
    }
    
    public func remove(section: Int = 0, position: Int) {
        if self[section].items.count <= position {
            return
        }
        self[section].items.remove(at: position)
        self.fastAdapter?.notifier.deleteItems(in: section, at: [IndexPath(row: position, section: section)])
    }
    
    public func setHeader(section: Int = 0, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) != nil {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
                    self?[section].header = item
                    self?.fastAdapter?.notifier.reloadSection(section: section)
                }
            }
        }
    }
    
    public func setFooter(section: Int = 0, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) != nil {
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
                    self?[section].footer = item
                    self?.fastAdapter?.notifier.reloadSection(section: section)
                }
            }
        }
    }
    
    public func expand(section: Int = 0, index: Int) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            let item = self?.sections[section].items[index]
            guard var expandable = item as? Expandable, !expandable.expanded else {
                return
            }
            guard let fastAdapter = self?.fastAdapter else {
                return
            }
            guard let measuredSubItems = expandable.getMeasuredSubItems(measurer: fastAdapter.measurer, width: frame?.width, height: frame?.height), measuredSubItems.count > 0 else {
                return
            }
            expandable.expanded = true
            let measuredSubItemsCount = measuredSubItems.count
            if self?.subItemCount[section] == nil {
                self?.subItemCount[section] = [Int : Int]()
            } else {
                // Count all keys up that higher then the current index
                if let keys = self?.subItemCount[section]?.keys {
                    for key in keys {
                        if key > index {
                            if let entry = self?.subItemCount[section]?.removeValue(forKey: key) {
                                self?.subItemCount[section]?[key + measuredSubItemsCount] = entry
                            }
                        }
                    }
                }
            }
            self?.subItemCount[section]?[index] = measuredSubItemsCount
            ItemList<Itm>.main {
                var indexPaths = [IndexPath]()
                var index = index + 1
                for item in measuredSubItems {
                    let _ = fastAdapter.typeInstanceCache.register(item: item)
                    self?[section].items.insert(item, at: index)
                    indexPaths.append(IndexPath(row: index, section: section))
                    index += 1
                }
                self?.fastAdapter?.notifier.insertItems(at: indexPaths)
            }
        }
    }
    
    public func collapse(section: Int = 0, index: Int) {
        if subItemCount[section]?.count ?? 0 <= section {
            return
        }
        guard var count = subItemCount[section]?[index], count > 0 else {
            return
        }
        addOperation {
            [weak self] in
            let item = self?.sections[section].items[index]
            guard var expandable = item as? Expandable, expandable.expanded else {
                return
            }
            expandable.expanded = false
            // Checks if an sub item is also expanded
            for i in index + 1...index + count {
                if let subItemCount = self?.subItemCount[section]?[i] {
                    count += subItemCount
                }
            }
            // Count all keys down that are higher then the current index
            if let keys = self?.subItemCount[section]?.keys {
                for key in keys {
                    if key > index {
                        if let entry = self?.subItemCount[section]?.removeValue(forKey: key) {
                            self?.subItemCount[section]?[key - count] = entry
                        }
                    }
                }
            }
            self?.sections[section].items.removeSubrange(index + 1...index + count)
            self?.subItemCount[section]?.removeValue(forKey: index)
            ItemList<Itm>.main {
                var indexPaths = [IndexPath]()
                for i in 1...count {
                    indexPaths.append(IndexPath(row: index + i, section: section))
                }
                self?.fastAdapter?.notifier.deleteItems(in: section, at: indexPaths)
            }
        }
    }
    
    public func toggleExpanded(section: Int = 0, index: Int) {
        guard let expandable = sections[section].items[index] as? Expandable else {
            return
        }
        if expandable.expanded {
            collapse(section: section, index: index)
        } else {
            expand(section: section, index: index)
        }
    }
    
    public func clear() {
        for (sectionIndex, section) in sections.enumerated() {
            _clearSection(sectionIndex: sectionIndex, section: section)
        }
    }
    
    public func clear(section: Int) {
        ItemList<Itm>.main {
            _clearSection(sectionIndex: section, section: self[section])
        }
    }
    
    private func _clearSection(sectionIndex: Int, section: Section<Itm>) {
        section.header = nil
        let count = section.items.count
        section.items.removeAll()
        section.footer = nil
        var indexPaths = [IndexPath]()
        for i in 0..<count {
            indexPaths.append(IndexPath(row: i, section: sectionIndex))
        }
        fastAdapter?.notifier.deleteItems(in: sectionIndex, at: indexPaths)
    }
    
    public func getExpandableOffset(section: Int = 0, index: Int) -> Int {
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
    
    open func addOperation(_ block: @escaping () -> Void) {
        fastAdapter?.backgroundLayoutQueue.addOperation(block)
    }
    
    static func main(_ block: () -> Void) {
        if Thread.current.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
    
    open func getFrame() -> CGRect? {
        let listView = fastAdapter?.listView
        if Thread.current.isMainThread {
            return listView?.frame
        } else {
            let frame = DispatchQueue.main.sync {
                return listView?.frame ?? CGRect.zero
            }
            if frame.width == 0 && frame.height == 0 {
                return nil
            }
            return frame
        }
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
