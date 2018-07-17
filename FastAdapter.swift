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
    var dataProvider: FastAdapterDataProvider<Itm>!
    var typeInstanceCache: TypeInstanceCache<Itm>!
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
    public init() {
        self.dataProvider = FastAdapterDataProvider<Itm>(fastAdapter: self)
        self.typeInstanceCache = TypeInstanceCache<Itm>(fastAdapter: self)
    }
    
    public func arrangement(width: CGFloat?, height: CGFloat?) {
        if let items = adapter?.itemList.items {
            for item in items {
                let _ = item.arrangement(width: width, height: height)
            }
            listView?.reloadData()
        }
    }
}

class FastAdapterDataProvider<Itm: Item>: FastAdapterDataProviderWrapper {
    private weak var fastAdapter: FastAdapter<Itm>?
    
    init(fastAdapter: FastAdapter<Itm>) {
        self.fastAdapter = fastAdapter
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fastAdapter?.adapter?.itemList.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.getType(), for: indexPath)
            item.makeViews(in: cell.contentView)
            return cell
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.typeInstances.first {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstType.key, for: indexPath)
            return cell
        }
        // Will crash when this happens
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return fastAdapter?.adapter?.itemList[safe: indexPath.row]?.arrangement?.frame.size ?? .zero
    }
}

class FastAdapterDataProviderWrapper: NSObject {
    
}

extension FastAdapterDataProviderWrapper: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension FastAdapterDataProviderWrapper: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
}

extension FastAdapterDataProviderWrapper: UICollectionViewDelegate {
    
}
