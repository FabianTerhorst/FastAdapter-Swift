//
//  Section.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 22.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class Section<Itm: Item> {
    
    public var header: Itm?
    public var items: [Itm]
    public var footer: Itm?
    public var supplementaryItems: [String: Itm]?
    
    public init(header: Itm? = nil, items: [Itm], footer: Itm? = nil, supplementaryItems: [String: Itm]? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
        self.supplementaryItems = supplementaryItems
    }
    
    public func map(_ mapper: (Itm) -> Itm) {
        self.header = self.header.map(mapper)
        self.items = self.items.map(mapper)
        self.footer = self.footer.map(mapper)
    }
}
