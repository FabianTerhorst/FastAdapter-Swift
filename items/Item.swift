//
//  Item.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import struct LayoutKit.LayoutArrangement
import protocol LayoutKit.Layout

open class Item {
    var arrangement: LayoutArrangement?
    
    open func getType() -> String {
        return String(describing: type(of: self))
    }
    
    open func getLayout() -> Layout? {
        return nil
    }
    
    open func getCell() -> AnyClass {
        return UICollectionViewCell.self
    }
    
    public init() {
        
    }
}

extension Item {
    public func arrangement(width: CGFloat?, height: CGFloat?) -> LayoutArrangement? {
        arrangement = getLayout()?.arrangement(width: width, height: height)
        return arrangement
    }
}
