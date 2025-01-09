
import UIKit

@objc public class Distance: IconData {
    public override init() {
        super.init()
        initDistance()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        initDistance()
    }

    private func initDistance() {
        setName("Distance")
        // max value is 999
        width = 20 * 3
        setIcon("icon_distance.png")
        setValueType(QjsValueType.distanceNum.rawValue)
    }
    
    public override func setIconAlign(_ align: Alignment) {
        super.setIconAlign(align)
        if align == .Left || align == .Right {
            width = 20 * 3 + 40
            height = 26
        } else {
            width = 20 * 3
            height = 26 + 40
        }
    }
}
