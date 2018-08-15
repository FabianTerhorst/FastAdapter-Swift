//
//  FastAdapter.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 11.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import class UIKit.UICollectionView
import struct LayoutKit.LayoutArrangement
import protocol LayoutKit.Layout

public extension FastAdapter {
    func with(listView: ListView) {
        listView.setListViewDelegate(delegate: dataProvider)
        listView.setListViewDataSource(dataSource: dataProvider)
        self.listView = listView
    }
}

public class FastAdapter<Itm: Item> {
    public let backgroundLayoutQueue: OperationQueue
    public var dataProvider: DataProvider<Itm> {
        didSet {
            dataProvider.fastAdapter = self
            listView?.setListViewDelegate(delegate: dataProvider)
            listView?.setListViewDataSource(dataSource: dataProvider)
        }
    }
    public var typeInstanceCache: TypeInstanceCache<Itm> {
        didSet {
            typeInstanceCache.fastAdapter = self
        }
    }
    public var measurer: Measurer<Itm> {
        didSet {
            measurer.fastAdapter = self
        }
    }
    public var notifier: Notifier<Itm> {
        didSet {
            notifier.fastAdapter = self
        }
    }
    public var listView: ListView? {
        didSet {
            typeInstanceCache.renew()
        }
    }
    public var logger: ((String) -> ())? = nil
    public let eventHooks = EventHooks<Itm>()
    public var adapter: Adapter<Itm>? {
        didSet {
            adapter?.fastAdapter = self
        }
    }
    
    public init(dataProvider: DataProvider<Itm> = DataProvider<Itm>(),
                typeInstanceCache: TypeInstanceCache<Itm> = TypeInstanceCache<Itm>(),
                measurer: Measurer<Itm> = Measurer<Itm>(),
                notifier: Notifier<Itm> = BatchNotifier<Itm>(),
                backgroundLayoutQueue: OperationQueue = DefaultLayoutQueue()) {
        self.backgroundLayoutQueue = backgroundLayoutQueue
        self.dataProvider = dataProvider
        self.typeInstanceCache = typeInstanceCache
        self.measurer = measurer
        self.notifier = notifier
        self.dataProvider.fastAdapter = self
        self.typeInstanceCache.fastAdapter = self
        self.measurer.fastAdapter = self
        self.notifier.fastAdapter = self
    }
}
