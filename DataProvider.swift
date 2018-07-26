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
    
    private func numberOfItemsInSection(section: Int) -> Int {
        return fastAdapter?.adapter?.itemList[section].items.count ?? 0
    }
    
    private func numberOfSections() -> Int {
        return fastAdapter?.adapter?.itemList.sections.count ?? 0
    }
    
    private func cellForItemAt(listView: ListView, indexPath: IndexPath) -> ListViewCell? {
        if let item = fastAdapter?.adapter?.itemList[indexPath.section].items[indexPath.row] {
            var cell = listView.dequeueReusableListViewCell(withReuseIdentifier: item.getType(), for: indexPath)
            item.onBind(indexPath: indexPath, cell: &cell)
            return cell
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.typeInstances.first {
            let cell = listView.dequeueReusableListViewCell(withReuseIdentifier: firstType.key, for: indexPath)
            return cell
        }
        return nil
    }
    
    private func viewForSupplementaryElement(listView: ListView, ofKind kind: String, at indexPath: IndexPath) -> (UIView & ListViewReusableView)? {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let item = fastAdapter?.adapter?.itemList[indexPath.section].header {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
        case UICollectionElementKindSectionFooter:
            if let item = fastAdapter?.adapter?.itemList[indexPath.section].footer {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
        default:
            if let item = fastAdapter?.adapter?.itemList[indexPath.section].supplementaryItems?[kind] {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
            assertionFailure("unknown supplementary view kind \(kind)")
        }
        // Last resort, should never happen
        if let firstType = fastAdapter?.typeInstanceCache.supplementaryViewTypeInstances[kind]?.first {
            let view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: firstType.key, for: indexPath)
            return view
        }
        return nil
    }
    
    private func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return fastAdapter?.adapter?.itemList[indexPath.section].items[indexPath.row].getSize() ?? .zero
    }
    
    private func sizeForHeader(in section: Int) -> CGSize {
        return fastAdapter?.adapter?.itemList[section].header?.getSize() ?? .zero
    }
    
    private func sizeForFooter(in section: Int) -> CGSize {
        return fastAdapter?.adapter?.itemList[section].footer?.getSize() ?? .zero
    }
    
    private func canMoveItem(at indexPath: IndexPath) -> Bool {
        return (fastAdapter?.adapter?.itemList[indexPath.section].items[indexPath.row] as? Draggable)?.isDraggable ?? false
    }
    
    private func move(moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fastAdapter?.adapter?.itemList.move(source: sourceIndexPath, destination: destinationIndexPath)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section: section)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section: section)
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItemAt(listView: collectionView, indexPath: indexPath) as! UICollectionViewCell? ?? super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         return cellForItemAt(listView: tableView, indexPath: indexPath) as! UITableViewCell? ?? super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryElement(listView: collectionView, ofKind: kind, at: indexPath) as! UICollectionReusableView? ?? super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForSupplementaryElement(listView: tableView, ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: section))
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForSupplementaryElement(listView: tableView, ofKind: UICollectionElementKindSectionFooter, at: IndexPath(row: 0, section: section))
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeForItem(at: indexPath).height
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForHeader(in: section)
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sizeForHeader(in: section).height
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sizeForFooter(in: section)
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sizeForFooter(in: section).height
    }
    
    public override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMoveItem(at: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveItem(at: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        move(moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        move(moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}

open class DataProviderWrapper: NSObject {
    
}

extension DataProviderWrapper: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
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
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}

extension DataProviderWrapper: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}

extension DataProviderWrapper: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
