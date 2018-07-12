//
//  Adapter.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class Adapter<Itm: Item> {
    public var order: Int = -1
    
    public var itemList: ItemList<Itm>!
    
    weak var fastAdapter: FastAdapter<Itm>? {
        didSet {
            itemList.fastAdapter = fastAdapter
        }
    }
}
