//
//  Arranger.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 18.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Measurer<Itm: Item> {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public init() {
        
    }
    
    open func measureItem(item: Itm) -> Bool {
        if let collectionView = fastAdapter?.listView {
            return measureItem(item: item, width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return false
    }
    
    open func measureItem(item: Itm, width: CGFloat?, height: CGFloat?) -> Bool {
        if width == nil && height == nil {
            return false
        }
        return item.onMeasure(width: width, height: nil)
    }
    
    open func renew() {
        if let collectionview = fastAdapter?.listView {
            let frame = collectionview.frame
            if let sections = fastAdapter?.adapter?.itemList.sections {
                for section in sections {
                    if let header = section.header {
                        let _ = measureItem(item: header, width: frame.width, height: frame.height)
                    }
                    for item in section.items {
                        let _ = measureItem(item: item, width: frame.width, height: frame.height)
                    }
                    if let footer = section.footer {
                        let _ = measureItem(item: footer, width: frame.width, height: frame.height)
                    }
                }
                fastAdapter?.listView?.reloadData()
            }
        }
    }
    
    open func renew(width: CGFloat?, height: CGFloat?) {
        if let sections = fastAdapter?.adapter?.itemList.sections {
            for section in sections {
                if let header = section.header {
                    let _ = measureItem(item: header, width: width, height: height)
                }
                for item in section.items {
                    let _ = measureItem(item: item, width: width, height: height)
                }
                if let footer = section.footer {
                    let _ = measureItem(item: footer, width: width, height: height)
                }
            }
            fastAdapter?.listView?.reloadData()
        }
    }
}
