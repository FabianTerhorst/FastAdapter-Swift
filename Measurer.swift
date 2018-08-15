//
//  Arranger.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 18.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Measurer<Itm: Item> {
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public let interceptor: (CGFloat?, CGFloat?, ListView?) -> (CGFloat?, CGFloat?, Bool)
    
    public init(interceptor: ((CGFloat?, CGFloat?, ListView?) -> (CGFloat?, CGFloat?, Bool))? = nil) {
        self.interceptor = interceptor ?? MeasurerDefaults.defaultInterceptor
    }
    
    open func measureItems(items: [Itm]) -> [Itm] {
        var measuredItems = [Itm]()
        for item in items {
            if measureItem(item: item) {
                measuredItems.append(item)
            }
        }
        return measuredItems
    }
    
    open func measureItem(item: Itm) -> Bool {
        guard let listView = fastAdapter?.listView else {
            return false
        }
        return measureItem(item: item, width: listView.frame.width, height: listView.frame.height)
    }
    
    open func measureItem(item: Itm, width: CGFloat?, height: CGFloat?) -> Bool {
        if let fastAdapter = fastAdapter as? FastAdapter<Item> {
            item.fastAdapter = fastAdapter
        }
        let (interceptedWidth, interceptedHeight, keep) = interceptor(width, height, self.fastAdapter?.listView)
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
        (width: CGFloat?, height: CGFloat?, listView: ListView?) -> (CGFloat?, CGFloat?, Bool) in
        return (width, nil, (width == nil && height == nil) ? false : true)
    }
}
