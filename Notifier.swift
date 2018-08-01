//
//  Notifier.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 23.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Notifier<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    public init() {
        
    }
    
    open func reloadData(listView: ListView) {
        listView.reloadData()
    }
    
    open func reloadSection(section: Int) {
        fastAdapter?.listView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    open func reloadItems(at indexPaths: [IndexPath]) {
        fastAdapter?.listView?.reloadItems(at: indexPaths, with: .automatic)
    }
    
    open func insertItems(at indexPaths: [IndexPath]) {
        fastAdapter?.listView?.insertItems(at: indexPaths, with: .automatic)
    }
    
    open func insertSections(_ sections: IndexSet) {
        fastAdapter?.listView?.insertSections(sections, with: .automatic)
    }
    
    open func insert(_ listView: ListView, _ itemList: ItemList<Itm>, section: Section<Itm>, at sectionIndex: Int) {
        itemList.sections.insert(Section<Itm>(header: nil, items: [Itm](), footer: nil), at: sectionIndex)
        listView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
    }
    
    open func delete(_ listView: ListView, _ itemList: ItemList<Itm>, sectionIndex: Int) {
        itemList.sections.remove(at: sectionIndex)
        listView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
    }
    
    open func insert(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], at index: Int, in section: Int) {
        _insert(listView, itemList, items: items, at: index, in: section, with: .automatic)
    }
    
    private func _insert(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], at index: Int, in section: Int, with animation: ListViewItemAnimation) {
        // Check if list is to short
        if itemList[section].items.count <= index - 1 {
            return
        }
        var indexPaths = [IndexPath]()
        itemList[section].items.insert(contentsOf: items, at: index)
        for i in index..<index + items.count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        listView.insertItems(at: indexPaths, with: animation)
    }
    
    open func delete(_ listView: ListView, _ itemList: ItemList<Itm>, count: Int, at index: Int, in section: Int) {
        _delete(listView, itemList, count: count, at: index, in: section, with: .automatic)
    }
    
    private func _delete(_ listView: ListView, _ itemList: ItemList<Itm>, count: Int, at index: Int, in section: Int, with animation: ListViewItemAnimation) {
        if itemList[section].items.count <= index + count - 1 {
            return
        }
        var indexPaths = [IndexPath]()
        for i in index..<index + count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        itemList[section].items.removeSubrange(index..<index + count)
        listView.deleteItems(at: indexPaths, with: animation)
    }
    
    open func update(_ listView: ListView, _ itemList: ItemList<Itm>, at index: Int, in section: Int) {
        if itemList[section].items.count <= index {
            return
        }
        listView.reloadItems(at: [IndexPath(row: index, section: section)], with: .automatic)
    }
    
    open func updateAll(_ listView: ListView, _ itemList: ItemList<Itm>, in section: Int) {
        var indexPaths = [IndexPath]()
        for i in 0..<itemList[section].items.count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        listView.reloadItems(at: indexPaths, with: .automatic)
    }
    
    open func clear(_ listView: ListView, _ itemList: ItemList<Itm>, section: Int) {
        let itemListSection = itemList[section]
        itemListSection.header = nil
        let count = itemListSection.items.count
        itemListSection.items.removeAll()
        itemListSection.footer = nil
        var indexPaths = [IndexPath]()
        for i in 0..<count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        listView.deleteItems(at: indexPaths, with: .automatic)
        // For header and footer clear we need to reload the complete section
        listView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    open func set(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], in section: Int) {
        itemList[section].items = items
        listView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    open func set(_ listView: ListView, _ itemList: ItemList<Itm>, item: Itm, at index: Int, in section: Int) {
        if itemList[section].items.count <= index {
            itemList[section].items.append(item)
            listView.reloadItems(at: [IndexPath(row: itemList[section].items.count - 1, section: section)], with: .automatic)
        } else {
            itemList[section].items[index] = item
            listView.reloadItems(at: [IndexPath(row: index, section: section)], with: .automatic)
        }
    }
    
    open func expand(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], at index: Int, in section: Int) {
        let itemsInSection = itemList[section].items
        if itemsInSection.count <= index {
            return
        }
        let item = itemsInSection[index]
        guard var expandable = item as? Expandable, !expandable.expanded else {
            return
        }
        expandable.expanded = true
        var measuredSubItemsCount = 0
        if let subItems = expandable.subItems {
            for subItem in subItems {
                guard subItem is Itm else {
                    continue
                }
                measuredSubItemsCount += 1
            }
        }
        if measuredSubItemsCount == 0 {
            return
        }
        
        // When list got unexpected shorter then the item index to expand stop expanding
        if itemList.sections[section].items.count <= index {
            return
        }
        
        if itemList.subItemCount[section] == nil {
            itemList.subItemCount[section] = [Int : Int]()
        } else {
            // Count all keys up that higher then the current index
            if let keys = itemList.subItemCount[section]?.keys {
                for key in keys {
                    if key > index {
                        if let entry = itemList.subItemCount[section]?.removeValue(forKey: key) {
                            itemList.subItemCount[section]?[key + measuredSubItemsCount] = entry
                        }
                    }
                }
            }
        }
        itemList.subItemCount[section]?[index] = measuredSubItemsCount
        _insert(listView, itemList, items: items, at: index + 1, in: section, with: .top)
    }
    
    open func collapse(_ listView: ListView, _ itemList: ItemList<Itm>, at index: Int, in section: Int) {
        if itemList.subItemCount[section]?.count ?? 0 <= section {
            return
        }
        guard var count = itemList.subItemCount[section]?[index], count > 0 else {
            return
        }
        let item = itemList[section].items[index]
        guard var expandable = item as? Expandable, expandable.expanded else {
            return
        }
        expandable.expanded = false
        // Checks if an sub item is also expanded
        for i in index + 1...index + count {
            if let subItemCount = itemList.subItemCount[section]?[i] {
                count += subItemCount
            }
        }
        
        // Prevent the _delete to return without correcting the subItemCount
        if itemList[section].items.count <= index + count {
            return
        }
        
        // Count all keys down that are higher then the current index
        if let keys = itemList.subItemCount[section]?.keys {
            for key in keys {
                if key > index {
                    if let entry = itemList.subItemCount[section]?.removeValue(forKey: key) {
                        itemList.subItemCount[section]?[key - count] = entry
                    }
                }
            }
        }
        itemList.subItemCount[section]?.removeValue(forKey: index)
        
        _delete(listView, itemList, count: count, at: index + 1, in: section, with: .top)
    }
}
