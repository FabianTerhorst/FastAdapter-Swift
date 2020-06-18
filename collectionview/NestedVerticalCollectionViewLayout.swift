//
//  NestedVerticalCollectionViewLayout.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 23.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

import LayoutKit
import UIKit

open class NestedVerticalCollectionViewLayout<V: FastAdapterCollectionView<Itm>, Itm: LayoutItem>: BaseLayout<V>, ConfigurableLayout {
    
    weak var fastAdapter: FastAdapter<Itm>?
    
    public init(fastAdapter: FastAdapter<Itm>, alignment: Alignment = .topFill, viewReuseId: String? = nil, config: ((V) -> Void)? = nil) {
        self.fastAdapter = fastAdapter
        if !(fastAdapter.measurer is NestedVerticalListViewLayoutMeasurer<Itm>) {
            self.fastAdapter?.measurer = NestedVerticalListViewLayoutMeasurer<Itm>()
        }
        if !(fastAdapter.notifier is NestedNotifier<Itm>) {
            self.fastAdapter?.notifier = NestedNotifier<Itm>(animationStack: BatchNotifier.Stack<BatchNotifier.NotifierType>())
        }
        super.init(alignment: alignment, flexibility: Flexibility(horizontal: nil, vertical: Flexibility.defaultFlex), viewReuseId: viewReuseId, config: config)
    }
    
    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let arrangements = (fastAdapter?.measurer as? NestedVerticalListViewLayoutMeasurer<Itm>)?.getArrangements(width: maxSize.width, height: nil) ?? [LayoutArrangement]()
        let fullHeight: CGFloat = arrangements.reduce(0, { (innerFullHeight: CGFloat, arrangement: LayoutArrangement) -> CGFloat in
            return innerFullHeight + arrangement.frame.height
        })
        // No intrinsic width, but want to be tall enough for all cell heights
        let size = CGSize(width: 0, height: min(fullHeight, maxSize.height))
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: [])
    }
    
    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = Alignment.fill.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }
    
    open override func configure(view: V) {
        super.configure(view: view)
        
        //view.fastAdapter?.backgroundLayoutQueue.addOperation {
        //    DispatchQueue.main.sync {
        
        //view.fastAdapter?.backgroundLayoutQueue.cancelAllOperations()
        view.fastAdapter?.backgroundLayoutQueue.addOperation {
            [weak self] in
            DispatchQueue.main.sync {
                [weak self] in
                self?.fastAdapter = view.fastAdapter
                view.fastAdapter?.with(listView: view)
                UIView.performWithoutAnimation {
                    view.reloadData()//TODO: maybe enough
                }
                //view.fastAdapter?.notifier.reloadData(listView: view)
            }
        }
        
         //       /*view.*/view.fastAdapter?.with(listView: view)
         //      view.reloadData()
        //    }
        //}
    }
    
    open override var needsView: Bool {
        return true
    }
}
