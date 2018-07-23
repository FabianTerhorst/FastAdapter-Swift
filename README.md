# FastAdapter-Swift

### TODO
- auto collapsing for expandable
- multi adapter support
- click listener
- event hooks
- selectable, selection, multiselection
- drag, drop
- filter
- split layoutkit items to different module
- add extension modules (endless scroll, waterfall layout)

### Untested
- expandable with more then one depth
- header, footer item
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
        let boundingBox = name(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    
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
fastAdapter.with(collectionView: collectionView)
...
modelAdapter.add(Device())
```
