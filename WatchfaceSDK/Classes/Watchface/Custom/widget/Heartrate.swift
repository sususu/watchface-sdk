
import UIKit

public class Heartrate: IconData {
    public override init() {
        super.init()
        initHeartrate()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        setName("Heartrate")
        initHeartrate()
    }

    private func initHeartrate() {
        // max value is 255
        width = 20 * 3
        setIcon("icon_heart.png")
        setValueType(QjsValueType.heartrateNum.rawValue)
    }
}