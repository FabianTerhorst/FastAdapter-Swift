//
//  DataProvider.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 19.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import UIKit

open class DataProvider<Itm: Item>: DataProviderWrapper {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public override init() {
    }
    
    private func numberOfItemsInSection(section: Int) -> Int {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return 0
        }
        if sections.count <= section {
            return 0
        }
        return sections[section].items.count
    }
    
    private func numberOfSections() -> Int {
        return fastAdapter?.adapter?.itemList.sections.count ?? 0
    }
    
    private func cellForItemAt(listView: ListView, indexPath: IndexPath) -> ListViewCell? {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return nil
        }
        if sections.count <= indexPath.section {
            return nil
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            fastAdapter?.logger?("Out of bounds at \(indexPath) in list \(listView)")
            return nil
        }
        let item = items[indexPath.row]
        let registered = fastAdapter?.typeInstanceCache.register(item: item) ?? true // Just to be sure its registered
        if !registered {
            fastAdapter?.logger?("Cell at \(indexPath) wasn't registered before in list \(listView)")
        }
        var cell = listView.dequeueReusableListViewCell(withReuseIdentifier: item.getType(), for: indexPath)
        item.onBind(indexPath: indexPath, cell: &cell)
        return cell
    }
    
    private func viewForSupplementaryElement(listView: ListView, ofKind kind: String, at indexPath: IndexPath) -> (UIView & ListViewReusableView)? {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return nil
        }
        if sections.count <= indexPath.section {
            return nil
        }
        let section = sections[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let item = section.header {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
        case UICollectionView.elementKindSectionFooter:
            if let item = section.footer {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
        default:
            if let item = section.supplementaryItems?[kind] {
                guard var view = listView.dequeueReusableListViewSupplementaryView(ofKind: kind, withReuseIdentifier: item.getType(), for: indexPath) else {
                    return nil
                }
                item.onBind(indexPath: indexPath, view: &view)
                return view
            }
            fastAdapter?.logger?("unknown supplementary view kind \(kind)")
        }
        return nil
    }
    
    private func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return .zero
        }
        if sections.count <= indexPath.section {
            return .zero
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            return .zero
        }
        return items[indexPath.row].getSize()
    }
    
    private func sizeForHeader(in section: Int) -> CGSize {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return .zero
        }
        if sections.count <= section {
            return .zero
        }
        return sections[section].header?.getSize() ?? .zero
    }
    
    private func sizeForFooter(in section: Int) -> CGSize {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return .zero
        }
        if sections.count <= section {
            return .zero
        }
        return sections[section].footer?.getSize() ?? .zero
    }
    
    private func canMoveItem(at indexPath: IndexPath) -> Bool {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return false
        }
        if sections.count <= indexPath.section {
            return false
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            return false
        }
        return (items[indexPath.row] as? Draggable)?.isDraggable ?? false
    }
    
    private func move(moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fastAdapter?.adapter?.itemList.move(source: sourceIndexPath, destination: destinationIndexPath)
    }
    
    public func shouldSelect(_ listView: ListView, at indexPath: IndexPath) -> Bool {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return false
        }
        if sections.count <= indexPath.section {
            return false
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            return false
        }
        if items[indexPath.row].isSelectable == true {
            /*if let selectedItems = listView.indexPathsForSelectedItems, !listView.allowsMultipleSelection {
                for indexPath in selectedItems {
                    updateSelection(listView, at: indexPath, selected: false)
                }
            }*/
            return true
        }
        return false
    }
    
    public func shouldDeselect(_ listView: ListView, at indexPath: IndexPath) -> Bool {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return false
        }
        if sections.count <= indexPath.section {
            return false
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            return false
        }
        return items[indexPath.row].isSelectable
    }
    
    public func updateSelection(_ listView: ListView, at indexPath: IndexPath, selected: Bool) {
        guard let sections = fastAdapter?.adapter?.itemList.sections else {
            return
        }
        if sections.count <= indexPath.section {
            return
        }
        let items = sections[indexPath.section].items
        if items.count <= indexPath.row {
            return
        }
        let item = items[indexPath.row]
        //TODO: shouldn't the system handle automatic deselection on allowsMultipleSelection = false ?
        if selected && !listView.allowsMultipleSelection, let sections = fastAdapter?.adapter?.itemList.sections {
            for (sectionIndex, section) in sections.enumerated() {
                for (itemIndex, item) in section.items.enumerated() {
                    if item.isSelected {
                        updateSelection(listView, at: IndexPath(row: itemIndex, section: sectionIndex), selected: false)
                    }
                }
            }
        }
        item.isSelected = selected
        // Not sure if we should call it always or optional with like updateOnSelector only for layout items
        if item is LayoutItem {
            fastAdapter?.adapter?.itemList.update(section: indexPath.section, index: indexPath.row)
        }
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
        return viewForSupplementaryElement(listView: tableView, ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section))
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForSupplementaryElement(listView: tableView, ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(row: 0, section: section))
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
    
    public override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelect(collectionView, at: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if shouldSelect(tableView, at: indexPath) {
            return indexPath
        }
        return nil
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelection(collectionView, at: indexPath, selected: true)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelection(tableView, at: indexPath, selected: true)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldDeselect(collectionView, at: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if shouldDeselect(tableView, at: indexPath) {
            return indexPath
        }
        return nil
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateSelection(collectionView, at: indexPath, selected: false)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateSelection(tableView, at: indexPath, selected: false)
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
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
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
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
