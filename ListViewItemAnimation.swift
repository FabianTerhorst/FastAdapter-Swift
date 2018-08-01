//
//  ListViewItemAnimation.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 01.08.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public enum ListViewItemAnimation {
    case fade
    case right
    case left
    case top
    case bottom
    case none
    case middle
    case automatic
}

extension ListViewItemAnimation {
    func toTableViewAnimation() -> UITableViewRowAnimation {
        switch self {
        case .fade:
            return .fade
        case .right:
            return .right
        case .left:
            return .left
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .none:
            return .none
        case .middle:
            return .middle
        case .automatic:
            return .automatic
        }
    }
}
