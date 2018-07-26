//
//  ListViewCell.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 26.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public protocol ListViewCell: class {
    var contentView: UIView { get }
    
    var isSelected: Bool { get set }
    
    var reuseIdentifier: String? { get }
    
    var layer: CALayer { get }
}

extension UICollectionViewCell: ListViewCell {
    
}

extension UITableViewCell: ListViewCell {
    
}
