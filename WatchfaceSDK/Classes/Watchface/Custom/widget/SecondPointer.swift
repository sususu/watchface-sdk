
import UIKit

public class SecondPointer: PointerWidgets {
    private var imageName: String = "pointer_second.png"

    public override init(watchfaceSize: Size) {
        super.init(watchfaceSize: watchfaceSize)
        self.initSecondPointer()
    }

    public init(_ watchfaceSize: Size, tintColor: UIColor) {
        super.init(watchfaceSize: watchfaceSize)
        self.tintColor = tintColor
        initSecondPointer()
    }

    private func initSecondPointer() {
        setName("SecondPointer")
        self.width = 6
        self.height = 247
        self.x = 230
        self.y = 11
        self.center = Point(x: 233, y: 233)
        self.rotationCenter = Point(x: 3, y: 222)
    }

    override func qjsWidgets() -> [Widget] {
        guard let bitmap = UIImage.loadImage(named: self.imageName) else {
            return []
        }
        if let color = getTintColor() {
            self.image = FileUtils.changeBitmapColor(originalBitmap: bitmap, color: color)
        } else {
            self.image = bitmap
        }

        var widgetList: [Widget] = []

        let pointerWidget = PointerWidget()
        pointerWidget.setValueType(QjsValueType.secondPointer.rawValue)
        pointerWidget.setCenterPoint(getCenter())
        pointerWidget.setRotationCenterPoint(getRotationCenter())
        pointerWidget.setImage(image!)
        widgetList.append(pointerWidget)

        return widgetList
    }
}
