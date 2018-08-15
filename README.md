# FastAdapter-Swift

### Features
- expandable items
- layoutkit support
- footer, header items
- multi sections
- background measuring
- modularity
- event hooks
- drag and drop
- collection and table view support

### TODO
- auto collapsing for expandable
- single expanded
- multi adapter support
- click listener
- selectable, selection, multiselection
- filter
- split layoutkit items to different module
- add extension modules (endless scroll, waterfall layout)

### Untested
- expandable with more then one depth
- items without using layoutkit

```swift
class DeviceItem: ModelLayoutItem<Device> {
    override func getLayout() -> Layout? {
        return DeviceLayout(device: model)
    }
}

class SampleItem: Item {
    
    private var size: CGSize?
    
    private let name: String
    
    private let font: UIFont
    
    init(name: String, font: UIFont) {
        self.name = name
        self.font = font
    }

    override func onBind(cell: inout UICollectionViewCell) {
        if let myCell = cell as? MyCollectionViewCell {
            myCell.nameLabel.text = name
            myCell.nameLabel.font = font
        }
    }
    
    override func getCell() -> AnyClass {
        return MyCollectionViewCell.self
    }
    
    override func onMeasure(width: CGFloat?, height: CGFloat?) -> Bool {
        guard let width = width, let height = heightWithConstrainedWidth(width, font: font) else {
            return false
        }
        size = CGSize(width: width, height: height)
        return true
    }
    
    override func getSize() -> CGSize {
        return size ?? .zero
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = name.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    
        return ceil(boundingBox.height)
    }
}
...
let fastAdapter = FastAdapter<DeviceItem>()
let modelAdapter = ModelAdapter<Device, DeviceItem>(interceptor: {
    model in
    return DeviceItem(model: device)
})
let itemAdapter = ItemAdapter<SampleItem>()
itemAdapter.add(SampleItem(name: name, font: font))
...
let itemAdapter = ItemAdapter<Item>()
itemAdapter.add(DeviceItem(model: device))
itemAdapter.add(SampleItem(name: name, font: font))
...
fastAdapter.adapter = modelAdapter
...
fastAdapter.with(listView: collectionView)
fastAdapter.with(listView: tableView)
...
modelAdapter.add(Device())
```

### Event hooks
```swift

public extension Events {
    public static let close = Event(name: "close")
}

class SampleEventHookItem: Item, Hookable {
    func someFunction() {
        self.event(.close)
    }
}

fastAdapter.eventHooks.add(on: .close) {
    [weak self] item, event in
    self?.dismiss(animated: true, completion: nil)
}
```

### Advanced event hooks
```swift

public extension Events {
    public static let customEvent = Event(name: "custom event")
}

class MyCustomEvent: Event {
    private let data: Data
    
    public init(data: Data) {
        self.data = data
        super.init(name: "custom event")
    }
}

class SampleEventHookItem: Item, Hookable {
    func someFunction() {
        self.event(MyCustomEvent(data: data))
    }
}

fastAdapter.eventHooks.add(on: .customEvent) {
    item, event in
    if let customEvent = event as? MyCustomEvent {
        print(customEvent.data)
    }
}
```
