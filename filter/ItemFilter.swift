//
//  ItemFilter.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 29.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

class ItemFilter<Itm: Item> {
    
    weak var fastAdapter: FastAdapter<Itm>?
    
    private let itemList: ItemList<Itm>
    
    public init(itemList: ItemList<Itm> = ItemList<Itm>()) {
        self.itemList = itemList
    }
    
    public func add(section: Int = 0, item: Itm) {
        itemList.add(section: section, item: item)
    }
    
    public func add(section: Int = 0, index: Int, item: Itm) {
        itemList.add(section: section, index: index, item: item)
    }
    
    public func addAll(section: Int = 0, items: [Itm]) {
        itemList.addAll(section: section, items: items)
    }
    
    public func set(section: Int = 0, items: [Itm]) {
        itemList.set(section: section, items: items)
    }
    
    public func set(section: Int = 0, index: Int, item: Itm) {
        itemList.set(section: section, index: index, item: item)
    }
    
    public func remove(section: Int = 0, index: Int) {
        itemList.remove(section: section, position: index)
    }
    
    public func update(section: Int = 0, index: Int) {
        itemList.update(section: section, index: index)
    }
    
    public func setHeader(section: Int = 0, item: Itm) {
        itemList.setHeader(section: section, item: item)
    }
    
    public func setFooter(section: Int = 0, item: Itm) {
        itemList.setFooter(section: section, item: item)
    }
    
    public func expanse(section: Int = 0, index: Int) {
        itemList.expand(section: section, index: index)
    }
    
    public func collapse(section: Int = 0, index: Int) {
        itemList.collapse(section: section, index: index)
    }
    
    public func toggleExpanded(section: Int = 0, index: Int) {
        itemList.toggleExpanded(section: section, index: index)
    }
    
    public func clear() {
        itemList.clear()
    }
    
    public func clear(section: Int) {
        itemList.clear(section: section)
    }
    
    public func addSection(_ section: Section<Itm>, at sectionIndex: Int) {
        itemList.addSection(section, at: sectionIndex)
    }
    
    public func deleteSection(at section: Int) {
        itemList.deleteSection(at: section)
    }
    
    public func getSections() -> [Section<Itm>] {
        return itemList.sections
    }
}
