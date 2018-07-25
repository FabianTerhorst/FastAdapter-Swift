//
//  EventHooks.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 25.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class EventHooks<Itm: Item> {
    var eventHooks = [Event: [(Itm, Event) -> ()]]()
    
    public func add(on event: Event, eventHook: @escaping (Itm, Event) -> ()) {
        if eventHooks[event] == nil {
            eventHooks[event] = [(Itm, Event) -> ()]()
        }
        eventHooks[event]?.append(eventHook)
    }
    
    func call(item: Itm, event: Event) {
        guard let eventHooksForEvent = eventHooks[event] else {
            return
        }
        for eventHook in eventHooksForEvent {
            eventHook(item, event)
        }
    }
}
