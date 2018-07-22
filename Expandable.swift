//
//  Expandable.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 22.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public protocol Expandable {
    var subItems: [Item]? { get set }
    var expanded: Bool { get set }
}

extension Expandable {
    func getMeasuredSubItems<Itm>(measurer: Measurer<Itm>, width: CGFloat?, height: CGFloat?) -> [Itm]? {
        var measuredSubItems: [Itm]?
        if let subItems = subItems {
            for subItem in subItems {
                guard let correctTypeSubItem = subItem as? Itm else {
                    continue
                }
                if measurer.measureItem(item: correctTypeSubItem, width: width, height: height) == true {
                    if measuredSubItems == nil {
                        measuredSubItems = [Itm]()
                    }
                    measuredSubItems?.append(correctTypeSubItem)
                }
            }
        }
        return measuredSubItems
    }
}
