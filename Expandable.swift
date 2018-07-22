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
