//
//  ItemAdapter.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class ItemAdapter<Itm: Item>: ModelAdapter<Itm, Itm> {
    public init(itemList: ItemList<Itm> = ItemList<Itm>()) {
        super.init(itemList: itemList) {
            item in
            return item
        }
    }
}
