//
//  DataProvider.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 19.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class DataProvider<Itm: Item>: DataProviderWrapper {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public override init() {
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fastAdapter?.adapter?.itemList[section].items.count ?? 0
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fastAdapter?.adapter?.itemList.sections.count ?? 0
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = fastAdapter?.adapter?.itemList[indexPath.section].items[indexPath.row] {
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.getType(), for: indexPath)
            item.onBind(cell: &cell)
            return cell
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.typeInstances.first {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstType.key, for: indexPath)
            return cell
        }
        // Will crash when this happens
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let item = fastAdapter?.adapter?.itemList[indexPath.section].header {
                var view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath)
                item.onBind(view: &view)
                return view
            }
        case UICollectionElementKindSectionFooter:
            if let item = fastAdapter?.adapter?.itemList[indexPath.section].footer {
                var view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath)
                item.onBind(view: &view)
                return view
            }
        default:
            assertionFailure("unknown supplementary view kind \(kind)")
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.typeInstances.first {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: firstType.key, for: indexPath)
            return view
        }
        // Will crash when this happens
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return fastAdapter?.adapter?.itemList[indexPath.section].items[indexPath.row].getSize() ?? .zero
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return fastAdapter?.adapter?.itemList[section].header?.getSize() ?? .zero
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return fastAdapter?.adapter?.itemList[section].footer?.getSize() ?? .zero
    }
}

open class DataProviderWrapper: NSObject {
    
}

extension DataProviderWrapper: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}

extension DataProviderWrapper: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
