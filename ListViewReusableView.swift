//
//  ListViewReusableView.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 26.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public protocol ListViewReusableView: class {
    var reuseIdentifier: String? { get }
}

extension UICollectionReusableView: ListViewReusableView {
    
}

extension UITableViewHeaderFooterView: ListViewReusableView {
    
}
