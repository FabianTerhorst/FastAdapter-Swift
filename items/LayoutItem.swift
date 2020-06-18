//
//  LayoutItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 19.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import LayoutKit
import UIKit
import CoreGraphics

open class LayoutItem: Item {
    
    // Needed for animation
    //weak var contentView: UIView?
    
    public var arrangement: LayoutArrangement?
    
    open override func onBind(indexPath: IndexPath, cell: inout ListViewCell) {
        super.onBind(indexPath: indexPath, cell: &cell)
        if let arrangement = arrangement {
            arrangement.makeViews(in: cell.contentView)
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
    }
    
    open override func onBind(indexPath: IndexPath, view: inout (UIView & ListViewReusableView)) {
        super.onBind(indexPath: indexPath, view: &view)
        if let arrangement = arrangement {
            arrangement.makeViews(in: view)
        }
    }
    
    open func getLayout() -> Layout? {
        return nil
    }
    
    /**
     Return is only used to determinate if item is measurable. Unmeasureable items will be ignored.
     **/
    open override func onMeasure(width: CGFloat?, height: CGFloat?) -> Bool {
        arrangement = getLayout()?.arrangement(width: width, height: height)
        return arrangement != nil
    }
    
    open override func getSize() -> CGSize {
        return arrangement?.frame.size ?? .zero
    }
}
