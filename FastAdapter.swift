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
    public var dataProvider: FastAdapterDataProvider<Itm> {
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
    public var arranger: Arranger<Itm> {
        didSet {
            arranger.fastAdapter = self
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
    
    public init(dataProvider: FastAdapterDataProvider<Itm> = FastAdapterDataProvider<Itm>(),
                typeInstanceCache: TypeInstanceCache<Itm> = TypeInstanceCache<Itm>(),
                arranger: Arranger<Itm> = Arranger<Itm>()) {
        self.dataProvider = dataProvider
        self.typeInstanceCache = typeInstanceCache
        self.arranger = arranger
        self.dataProvider.fastAdapter = self
        self.typeInstanceCache.fastAdapter = self
        self.arranger.fastAdapter = self
    }
    
    public func arrangement(width: CGFloat?, height: CGFloat?) {
        if let items = adapter?.itemList.items {
            for item in items {
                let _ = arranger.arrangeItem(item: item, width: width, height: height)
            }
            listView?.reloadData()
        }
    }
    
    public func arrangement() {
        if let listView = self.listView {
            let frame = listView.frame
            if let items = adapter?.itemList.items {
                for item in items {
                    let _ = arranger.arrangeItem(item: item, width: frame.width, height: frame.height)
                }
                listView.reloadData()
            }
        }
    }
}

open class FastAdapterDataProvider<Itm: Item>: FastAdapterDataProviderWrapper {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public override init() {
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fastAdapter?.adapter?.itemList.count ?? 0
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = fastAdapter?.adapter?.itemList[safe: indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.getType(), for: indexPath)
            return item.onBind(cell: cell)
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.typeInstances.first {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstType.key, for: indexPath)
            return cell
        }
        // Will crash when this happens
        return UICollectionViewCell()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return fastAdapter?.adapter?.itemList[safe: indexPath.row]?.getSize() ?? .zero
    }
}

open class FastAdapterDataProviderWrapper: NSObject {
    
}

extension FastAdapterDataProviderWrapper: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension FastAdapterDataProviderWrapper: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
}

extension FastAdapterDataProviderWrapper: UICollectionViewDelegate {
    
}
