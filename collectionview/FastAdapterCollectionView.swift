//
//  FastAdapterCollectionView.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 24.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import UIKit
import Foundation

open class FastAdapterCollectionView<Itm: Item>: UICollectionView {
    
    public weak var fastAdapter: FastAdapter<Itm>?
    
    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
