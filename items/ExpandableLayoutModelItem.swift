//
//  ExpandableLayoutModelItem.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 22.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class ExpandableLayoutModelItem<Model, Itm: Item>: ModelLayoutItem<Model> {
    var expanded: Bool = false
    var subItems: [Itm]? = nil
}
