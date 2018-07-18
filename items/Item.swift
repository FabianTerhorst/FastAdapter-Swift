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
    
    public init() {
        
    }
}

public extension Item {
    func arrangement(width: CGFloat?, height: CGFloat?) -> LayoutArrangement? {
        arrangement = getLayout()?.arrangement(width: width, height: height)
        return arrangement
    }
    
    func makeViews(in view: UIView) {
        /*if let contentView = contentView {
            if let animation = arrangement?.prepareAnimation(for: contentView) {
                UIView.animate(withDuration: 5.0, animations: animation.apply, completion: { (_) in
                })
            }
        } else {*/
        arrangement?.makeViews(in: view)
        //}
        //contentView = view
    }
}
