//
//  Arranger.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 18.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Measurer<Itm: Item> {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public let interceptor: (CGFloat?, CGFloat?) -> (CGFloat?, CGFloat?, Bool)
    
    public init(interceptor: ((CGFloat?, CGFloat?) -> (CGFloat?, CGFloat?, Bool))? = nil) {
        self.interceptor = interceptor ?? MeasurerDefaults.defaultInterceptor
    }
    
    open func measureItem(item: Itm) -> Bool {
        guard let collectionView = fastAdapter?.listView else {
            return false
        }
        return measureItem(item: item, width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    open func measureItem(item: Itm, width: CGFloat?, height: CGFloat?) -> Bool {
        if let fastAdapter = fastAdapter as? FastAdapter<Item> {
            item.fastAdapter = fastAdapter
        }
        let (interceptedWidth, interceptedHeight, keep) = interceptor(width, height)
        if !keep {
            return false
        }
        return item.onMeasure(width: interceptedWidth, height: interceptedHeight)
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

class MeasurerDefaults {
    public static let defaultInterceptor = {
        (width: CGFloat?, height: CGFloat?) -> (CGFloat?, CGFloat?, Bool) in
        return (width, nil, (width == nil && height == nil) ? false : true)
    }
}
