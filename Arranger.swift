//
//  Arranger.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 18.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import struct LayoutKit.LayoutArrangement

open class Arranger<Itm: Item> {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public init() {
        
    }
    
    open func arrangeItem(item: Itm) -> Bool {
        if let collectionView = fastAdapter?.listView {
            return arrangeItem(item: item, width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return false
    }
    
    open func arrangeItem(item: Itm, width: CGFloat?, height: CGFloat?) -> Bool {
        return item.onMeasure(width: width, height: nil)
    }
}
