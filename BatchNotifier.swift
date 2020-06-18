//
//  BatchNotifier.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 28.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import Foundation

public class BatchNotifier<Itm: Item>: Notifier<Itm> {
    
    public struct Stack<T> {
        fileprivate var array = [T]()
        
        public init() {
            
        }
        
        public var isEmpty: Bool {
            return array.isEmpty
        }
        
        public var count: Int {
            return array.count
        }
        
        public mutating func push(_ element: T) {
            array.append(element)
        }
        
        public mutating func pop() -> T? {
            return array.popLast()
        }
        
        public var top: T? {
            return array.last
        }
        
        public mutating func clear() {
            array.removeAll()
        }
    }
    
    public enum NotifierType {
        case reloadSection(ListView, Int)
        case insertSections(ListView, IndexSet)
        case insertSection(ListView, ItemList<Itm>, Section<Itm>, Int)
        case deleteSection(ListView, ItemList<Itm>, Int)
        case reloadItems(ListView, [IndexPath])
        case insertItems(ListView, [IndexPath])
        case insert(ListView, ItemList<Itm>, [Itm], Int, Int)
        case delete(ListView, ItemList<Itm>, Int, Int, Int)
        case update(ListView, ItemList<Itm>, Int, Int)
        case updateAll(ListView, ItemList<Itm>, Int)
        case clearSection(ListView, ItemList<Itm>, Int)
        case set(ListView?, ItemList<Itm>, [Itm], Int)
        case setItem(ListView, ItemList<Itm>, Itm, Int, Int)
        case expand(ListView, ItemList<Itm>, [Itm], Int, Int)
        case reloadData(ListView)
        case execute(() -> ())
    }
    
    public var animationStack: Stack<NotifierType>
    
    public init(animationStack: Stack<NotifierType> = Stack<NotifierType>()) {
        self.animationStack = animationStack
    }
    
    public override func reloadData(listView: ListView) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        addToBatchUpdate(.reloadData(listView))
    }
    
    public override func reloadSection(section: Int) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        addToBatchUpdate(.reloadSection(listView, section))
    }
    
    public override func insertSections(_ sections: IndexSet) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        addToBatchUpdate(.insertSections(listView, sections))
    }
    
    override public func reloadItems(at indexPaths: [IndexPath]) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        addToBatchUpdate(.reloadItems(listView, indexPaths))
    }
    
    public override func insertItems(at indexPaths: [IndexPath]) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        addToBatchUpdate(.insertItems(listView, indexPaths))
    }
    
    public override func insert(_ listView: ListView, _ itemList: ItemList<Itm>, section: Section<Itm>, at sectionIndex: Int) {
        addToBatchUpdate(.insertSection(listView, itemList, section, sectionIndex))
    }
    
    public override func delete(_ listView: ListView, _ itemList: ItemList<Itm>, sectionIndex: Int) {
        addToBatchUpdate(.deleteSection(listView, itemList, sectionIndex))
    }
    
    public override func insert(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], at index: Int, in section: Int) {
        addToBatchUpdate(.insert(listView, itemList, items, index, section))
    }
    
    public override func delete(_ listView: ListView, _ itemList: ItemList<Itm>, count: Int, at index: Int, in section: Int) {
        addToBatchUpdate(.delete(listView, itemList, count, index, section))
    }
    
    public override func update(_ listView: ListView, _ itemList: ItemList<Itm>, at index: Int, in section: Int) {
        addToBatchUpdate(.update(listView, itemList, index, section))
    }
    
    public override func updateAll(_ listView: ListView, _ itemList: ItemList<Itm>, in section: Int) {
        addToBatchUpdate(.updateAll(listView, itemList, section))
    }
    
    public override func clear(_ listView: ListView, _ itemList: ItemList<Itm>, section: Int) {
        addToBatchUpdate(.clearSection(listView, itemList, section))
    }
    
    public override func set(_ listView: ListView?, _ itemList: ItemList<Itm>, items: [Itm], in section: Int) {
        addToBatchUpdate(.set(listView, itemList, items, section))
    }
    
    public override func set(_ listView: ListView, _ itemList: ItemList<Itm>, item: Itm, at index: Int, in section: Int) {
        addToBatchUpdate(.setItem(listView, itemList, item, index, section))
    }
    
    public override func expand(_ listView: ListView, _ itemList: ItemList<Itm>, items: [Itm], at index: Int, in section: Int) {
        addToBatchUpdate(.expand(listView, itemList, items, index, section))
    }
    
    public func execute(execute: @escaping () -> ()) {
        addToBatchUpdate(.execute(execute))
    }
    
    private func addToBatchUpdate(_ type: NotifierType) {
        if animationStack.isEmpty {
            executeBatchUpdate(type)
        } else {
            animationStack.push(type)
        }
    }
    
    private func executeBatchUpdate(_ type: NotifierType) {
        if let listView = fastAdapter?.listView {
            if !Thread.current.isMainThread {
                DispatchQueue.main.sync {
                    [weak self] in
                    listView.performListViewBatchUpdates({
                        [weak self] in
                        self?.execute(type)
                        }, completion: {
                            [weak self] result in
                            if let type = self?.animationStack.pop() {
                                self?.executeBatchUpdate(type)
                            }
                    })
                }
            } else {
                listView.performListViewBatchUpdates({
                    [weak self] in
                    self?.execute(type)
                    }, completion: {
                        [weak self] result in
                        if let type = self?.animationStack.pop() {
                            self?.executeBatchUpdate(type)
                        }
                })
            }
        } else {
            execute(type)
            if let type = animationStack.pop() {
                executeBatchUpdate(type)
            }
        }
    }
    
    private func execute(_ type: NotifierType) {
        switch type {
        case .reloadSection(let listView, let section):
            listView.reloadSections(IndexSet(integer: section), with: .automatic)
        case .insertSections(let listView, let sections):
            listView.insertSections(sections, with: .automatic)
        case .reloadItems(let listView, let indexPaths):
            listView.reloadItems(at: indexPaths, with: .automatic)
        case .insertItems(let listView, let indexPaths):
            listView.insertItems(at: indexPaths, with: .automatic)
        case .insertSection(let listView, let itemList, let section, let sectionIndex):
            super.insert(listView, itemList, section: section, at: sectionIndex)
        case .deleteSection(let listView, let itemList, let sectionIndex):
            super.delete(listView, itemList, sectionIndex: sectionIndex)
        case .insert(let listView, let itemList, let items, let index, let section):
            super.insert(listView, itemList, items: items, at: index, in: section)
        case .delete(let listView, let itemList, let count, let index, let section):
            super.delete(listView, itemList, count: count, at: index, in: section)
        case .update(let listView, let itemList, let index, let section):
            super.update(listView, itemList, at: index, in: section)
        case .updateAll(let listView, let itemList, let section):
            super.updateAll(listView, itemList, in: section)
        case .clearSection(let listView, let itemList, let section):
            super.clear(listView, itemList, section: section)
        case .set(let listView, let itemList, let items, let section):
            super.set(listView, itemList, items: items, in: section)
        case .setItem(let listView, let itemList, let item, let index, let section):
            super.set(listView, itemList, item: item, at: index, in: section)
        case .expand(let listView, let itemList, let items, let index, let section):
            super.expand(listView, itemList, items: items, at: index, in: section)
        case .reloadData(let listView):
            super.reloadData(listView: listView)
        case .execute(let execute):
            execute()
        }
    }
}
