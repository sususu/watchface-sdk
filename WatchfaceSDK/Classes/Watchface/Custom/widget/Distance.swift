
import UIKit

public class Distance: IconData {
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
}
