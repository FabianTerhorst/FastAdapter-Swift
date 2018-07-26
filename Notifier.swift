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
    
    open func reloadSection(section: Int) {
        fastAdapter?.listView?.reloadSections(IndexSet(integer: section))
    }
    
    open func reloadItems(at indexPaths: [IndexPath]) {
        fastAdapter?.listView?.reloadItems(at: indexPaths)
    }
    
    open func insertItems(at indexPaths: [IndexPath]) {
        fastAdapter?.listView?.insertItems(at: indexPaths)
    }
    
    open func deleteItems(in section: Int, at indexPaths: [IndexPath]) {
        guard let listView = fastAdapter?.listView else {
            return
        }
        listView.performListViewBatchUpdates({
            listView.deleteItems(at: indexPaths)
        }, completion: {
            finished in
            listView.reloadSections(IndexSet(integer: section))
        })
    }
}
