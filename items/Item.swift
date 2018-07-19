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
    public var arrangement: LayoutArrangement?
    
    // Needed for animation
    //weak var contentView: UIView?
    
    open func getType() -> String {
        return String(describing: type(of: self))
    }
    
    open func getLayout() -> Layout? {
        return nil
    }
    
    open func getCell() -> AnyClass {
        return UICollectionViewCell.self
    }
    
    open func onBind(cell: UICollectionViewCell) -> UICollectionViewCell {
        arrangement?.makeViews(in: cell.contentView)
        return cell
    }
    
    /**
     Return is only used to determinate if item is measurable. Unmeasureable items will be ignored.
    **/
    open func onMeasure(width: CGFloat?, height: CGFloat?) -> Bool {
        arrangement = getLayout()?.arrangement(width: width, height: height)
        return arrangement != nil
    }
    
    open func getSize() -> CGSize {
        return arrangement?.frame.size ?? .zero
    }
    
    public init() {
        
    }
}
