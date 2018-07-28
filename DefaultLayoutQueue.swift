//
//  DefaultLayoutQueue.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 28.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class DefaultLayoutQueue: OperationQueue {
    public override init() {
        super.init()
        name = String(describing: DefaultLayoutQueue.self)
        maxConcurrentOperationCount = 1
        qualityOfService = .userInitiated
    }
}
