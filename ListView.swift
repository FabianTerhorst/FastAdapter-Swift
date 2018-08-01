//
//  ListView.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 26.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public protocol ListView: class {
    var frame: CGRect { get }
    
    var allowsSelection: Bool { get set }
    
    var allowsMultipleSelection: Bool { get set }
    
    var indexPathsForSelectedItems: [IndexPath]? { get }
    
    func setListViewDelegate(delegate: DataProviderWrapper)
    
    func setListViewDataSource(dataSource: DataProviderWrapper)
    
    func registerCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String)
    
    func registerCell(_ nib: UINib?, forCellWithReuseIdentifier identifier: String)
    
    func registerCell(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String)
    
    func registerCell(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String)
    
    func dequeueReusableListViewCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> ListViewCell
    
    func dequeueReusableListViewSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> (UIView & ListViewReusableView)?
    
    func insertSections(_ sections: IndexSet, with animation: ListViewItemAnimation)
    
    func deleteSections(_ sections: IndexSet, with animation: ListViewItemAnimation)
    
    func reloadSections(_ sections: IndexSet, with animation: ListViewItemAnimation)
    
    func moveSection(_ section: Int, toSection newSection: Int)
    
    func insertItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation)
    
    func deleteItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation)
    
    func reloadItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation)
    
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)
    
    func reloadData()
    
    func selectItem(at indexPath: IndexPath?,
                    animated: Bool,
                    scrollPosition: UICollectionView.ScrollPosition)
    
    func indexPath(for cell: ListViewCell) -> IndexPath?
    
    func performListViewBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
}

extension UICollectionView: ListView {
    public func setListViewDelegate(delegate: DataProviderWrapper) {
        self.delegate = delegate
    }
    
    public func setListViewDataSource(dataSource: DataProviderWrapper) {
        self.dataSource = dataSource
    }
    
    public func registerCell(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        register(viewClass ?? UICollectionViewCell.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
    }
    
    public func registerCell(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    public func registerCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        register(cellClass ?? UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    public func registerCell(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func dequeueReusableListViewCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> ListViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func dequeueReusableListViewSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> (UIView & ListViewReusableView)? {
        return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func insertSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        insertSections(sections)
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        deleteSections(sections)
    }
    
    public func reloadSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        reloadSections(sections)
    }
    
    public func insertItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        insertItems(at: indexPaths)
    }
    
    public func deleteItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        deleteItems(at: indexPaths)
    }
    
    public func reloadItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        reloadItems(at: indexPaths)
    }
    
    public func indexPath(for cell: ListViewCell) -> IndexPath? {
        if let cell = cell as? UICollectionViewCell {
            return indexPath(for: cell)
        }
        return nil
    }
    
    public func performListViewBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        performBatchUpdates(updates, completion: completion)
    }
}

extension UITableView: ListView {
    public var indexPathsForSelectedItems: [IndexPath]? {
        get {
            if let indexPathsForSelectedRows = indexPathsForSelectedRows {
                return indexPathsForSelectedRows
            }
            if let indexPathForSelectedRow = indexPathForSelectedRow {
                return [indexPathForSelectedRow]
            }
            return nil
        }
    }
    
    public func setListViewDelegate(delegate: DataProviderWrapper) {
        self.delegate = delegate
    }
    
    public func setListViewDataSource(dataSource: DataProviderWrapper) {
        self.dataSource = dataSource
    }
    
    public func registerCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        register(cellClass ?? UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    public func registerCell(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerCell(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        register(viewClass ?? UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerCell(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) {
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func dequeueReusableListViewCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> ListViewCell {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    public func dequeueReusableListViewSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> (UIView & ListViewReusableView)? {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }
    
    public func insertSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        insertSections(sections, with: animation.toTableViewAnimation())
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        deleteSections(sections, with: animation.toTableViewAnimation())
    }
    
    public func reloadSections(_ sections: IndexSet, with animation: ListViewItemAnimation) {
        reloadSections(sections, with: animation.toTableViewAnimation())
    }
    
    public func insertItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        insertRows(at: indexPaths, with: animation.toTableViewAnimation())
    }
    
    public func deleteItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        deleteRows(at: indexPaths, with: animation.toTableViewAnimation())
    }
    
    public func reloadItems(at indexPaths: [IndexPath], with animation: ListViewItemAnimation) {
        reloadRows(at: indexPaths, with: animation.toTableViewAnimation())
    }
    
    public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        moveRow(at: indexPath, to: indexPath)
    }
    
    public func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        let tableViewScrollPosition: UITableView.ScrollPosition
        switch scrollPosition {
        case .top:
            tableViewScrollPosition = .top
        case .bottom:
            tableViewScrollPosition = .bottom
        case .centeredVertically:
            tableViewScrollPosition = .middle
        case .left, .right, .centeredHorizontally:
            tableViewScrollPosition = .none
        default:
            tableViewScrollPosition = .none
        }
        selectRow(at: indexPath, animated: animated, scrollPosition: tableViewScrollPosition)
    }
    
    public func indexPath(for cell: ListViewCell) -> IndexPath? {
        if let cell = cell as? UITableViewCell {
            return indexPath(for: cell)
        }
        return nil
    }
    
    public func performListViewBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        if #available(iOS 11.0, *) {
            performBatchUpdates(updates, completion: completion)
        } else {
            if let updates = updates {
                updates()
            }
            if let completion = completion {
                completion(true)
            }
        }
    }
}
