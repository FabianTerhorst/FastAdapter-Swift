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
        return sections[position]
    }
    
    public func addSection(_ section: Section<Itm>, at sectionIndex: Int) {
        if let listView = fastAdapter?.listView {
            fastAdapter?.notifier.insert(listView, self, section: section, at: sectionIndex)
        }
    }
    
    public func deleteSection(at sectionIndex: Int) {
        if let listView = fastAdapter?.listView {
            fastAdapter?.notifier.delete(listView, self, sectionIndex: sectionIndex)
        }
    }
    
    public func add(section: Int = 0, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    if let itemList = self, let listView = self?.fastAdapter?.listView {
                        self?.fastAdapter?.notifier.insert(listView, itemList, items: [item], at: itemList[section].items.count, in: section)
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
                    if let itemList = self, let listView = self?.fastAdapter?.listView {
                        self?.fastAdapter?.notifier.insert(listView, itemList, items: [item], at: index, in: section)
                    }
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            guard let arrangedItems = self?.fastAdapter?.measurer.measureItems(items: items, width: frame?.width, height: frame?.height) else {
                return
            }
            ItemList<Itm>.main {
                let _ = self?.fastAdapter?.typeInstanceCache.register(items: arrangedItems)
                if let itemList = self, let listView = self?.fastAdapter?.listView {
                    self?.fastAdapter?.notifier.insert(listView, itemList, items: arrangedItems, at: itemList[section].items.count, in: section)
                }
            }
        }
    }
    
    public func addAll(section: Int = 0, index: Int, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            guard let arrangedItems = self?.fastAdapter?.measurer.measureItems(items: items, width: frame?.width, height: frame?.height) else {
                return
            }
            ItemList<Itm>.main {
                let _ = self?.fastAdapter?.typeInstanceCache.register(items: arrangedItems)
                if let itemList = self, let listView = self?.fastAdapter?.listView {
                    self?.fastAdapter?.notifier.insert(listView, itemList, items: arrangedItems, at: index, in: section)
                }
            }
        }
    }
    
    open func set(section: Int = 0, items: [Itm]) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            guard let arrangedItems = self?.fastAdapter?.measurer.measureItems(items: items, width: frame?.width, height: frame?.height) else {
                return
            }
            ItemList<Itm>.main {
                let _ = self?.fastAdapter?.typeInstanceCache.register(items: arrangedItems)
                if let itemList = self, let listView = self?.fastAdapter?.listView {
                    self?.fastAdapter?.notifier.set(listView, itemList, items: arrangedItems, in: section)
                }
            }
        }
    }
    
    public func update(section: Int = 0, index: Int) {
        let sectionItems = self[section].items
        if sectionItems.count <= index {
            return
        }
        let item = sectionItems[index]
        let frame = getFrame()
        addOperation {
            [weak self] in
                if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    if let itemList = self, let listView = self?.fastAdapter?.listView {
                        self?.fastAdapter?.notifier.update(listView, itemList, at: index, in: section)
                    }
                }
            }
        }
    }
    
    public func updateAll(section: Int = 0) {
        if sections.count <= section {
            return
        }
        let frame = getFrame()
        let items = self[section].items
        addOperation {
            [weak self] in
            for item in items {
                let _ = self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height)
            }
            ItemList<Itm>.main {
                if let itemList = self, let listView = self?.fastAdapter?.listView {
                    self?.fastAdapter?.notifier.updateAll(listView, itemList, in: section)
                }
            }
        }
    }
    
    public func set(section: Int = 0, index: Int, item: Itm) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item)
                    if let itemList = self, let listView = self?.fastAdapter?.listView {
                        self?.fastAdapter?.notifier.set(listView, itemList, item: item, at: index, in: section)
                    }
                }
            }
        }
    }
    
    public func remove(section: Int = 0, position: Int) {
        if let listView = fastAdapter?.listView {
            fastAdapter?.notifier.delete(listView, self, count: 1, at: position, in: section)
        }
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
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
                    self?[section].footer = item
                    self?.fastAdapter?.notifier.reloadSection(section: section)
                }
            }
        }
    }
    
    public func setSupplementary(item: Itm, ofKind kind: String, in section: Int = 0) {
        let frame = getFrame()
        addOperation {
            [weak self] in
            if self?.fastAdapter?.measurer.measureItem(item: item, width: frame?.width, height: frame?.height) == true {
                ItemList<Itm>.main {
                    let _ = self?.fastAdapter?.typeInstanceCache.register(item: item, forSupplementaryViewOfKind: kind)
                    if self?[section].supplementaryItems == nil {
                        self?[section].supplementaryItems = [String: Itm]()
                    }
                    self?[section].supplementaryItems?[kind] = item
                    self?.fastAdapter?.notifier.reloadSection(section: section)
                }
            }
        }
    }
    
    public func expand(section: Int = 0, index: Int) {
        let frame = getFrame()
        let sectionItems = self[section].items
        if sectionItems.count <= index {
            return
        }
        let item = sectionItems[index]
        addOperation {
            [weak self] in
            guard let fastAdapter = self?.fastAdapter else {
                return
            }
            guard let measuredSubItems = (item as? Expandable)?.getMeasuredSubItems(measurer: fastAdapter.measurer, width: frame?.width, height: frame?.height), measuredSubItems.count > 0 else {
                return
            }
            ItemList<Itm>.main {
                let _ = fastAdapter.typeInstanceCache.register(items: measuredSubItems)
                if let itemList = self, let listView = self?.fastAdapter?.listView {
                    self?.fastAdapter?.notifier.expand(listView, itemList, items: measuredSubItems, at: index, in: section)
                }
            }
        }
    }
    
    public func collapse(section: Int = 0, index: Int) {
        ItemList<Itm>.main {
            if let listView = fastAdapter?.listView {
                fastAdapter?.notifier.collapse(listView, self, at: index, in: section)
            }
        }
    }
    
    public func toggleExpanded(section: Int = 0, index: Int) {
        let sectionItems = sections[section].items
        if sectionItems.count <= index {
            return
        }
        guard let expandable = sectionItems[index] as? Expandable else {
            return
        }
        if expandable.expanded {
            collapse(section: section, index: index)
        } else {
            expand(section: section, index: index)
        }
    }
    
    public func move(source: IndexPath, destination: IndexPath) {
        if sections.count <= source.section || sections.count <= destination.section {
            return
        }
        if self[source.section].items.count <= source.row || self[destination.section].items.count <= destination.row {
            return
        }
        let item = self[source.section].items.remove(at: source.row)
        self[destination.section].items.insert(item, at: destination.row)
    }
    
    public func clear() {
        ItemList<Itm>.main {
            for (sectionIndex, _) in sections.enumerated() {
                if let listView = fastAdapter?.listView {
                    fastAdapter?.notifier.clear(listView, self, section: sectionIndex)
                }
            }
        }
    }
    
    public func clear(section: Int) {
        ItemList<Itm>.main {
            if let listView = fastAdapter?.listView {
                fastAdapter?.notifier.clear(listView, self, section: section)
            }
        }
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
