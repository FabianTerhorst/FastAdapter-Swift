# FastAdapter-Swift

```swift
class DeviceItem: ModelItem<Device> {
    override func getLayout() -> Layout? {
        return DeviceLayout(device: model)
    }
}
...
let fastAdapter = FastAdapter<DeviceItem>()
let modelAdapter: ModelAdapter<Device, DeviceItem>(interceptor: {
    model in
    return DeviceItem(model: device)
})
...
fastAdapter.adapter = modelAdapter
...
fastAdapter.with(collectionView: collectionView)
...
modelAdapter.add(Device())
```
