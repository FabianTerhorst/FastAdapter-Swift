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
    func with(collectionView: UICollectionView) {
        collectionView.dataSource = dataProvider
        collectionView.delegate = dataProvider
        listView = collectionView
    }
}

public class FastAdapter<Itm: Item> {
    let backgroundLayoutQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = String(describing: FastAdapter.self)
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue
    }()
    public var dataProvider: DataProvider<Itm> {
        didSet {
            dataProvider.fastAdapter = self
            listView?.dataSource = dataProvider
            listView?.delegate = dataProvider
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
    var listView: UICollectionView? {
        didSet {
            typeInstanceCache.renew()
        }
    }
    public var adapter: Adapter<Itm>? {
        didSet {
            adapter?.fastAdapter = self
        }
    }
    
    public init(dataProvider: DataProvider<Itm> = DataProvider<Itm>(),
                typeInstanceCache: TypeInstanceCache<Itm> = TypeInstanceCache<Itm>(),
                measurer: Measurer<Itm> = Measurer<Itm>()) {
        self.dataProvider = dataProvider
        self.typeInstanceCache = typeInstanceCache
        self.measurer = measurer
        self.dataProvider.fastAdapter = self
        self.typeInstanceCache.fastAdapter = self
        self.measurer.fastAdapter = self
    }
}
