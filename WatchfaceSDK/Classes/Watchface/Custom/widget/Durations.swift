
import UIKit

public class Durations: IconData {
    public override init() {
        super.init()
        initDuration()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        initDuration()
    }

    private func initDuration() {
        setName("Duration")
        // max value is 999
        width = 20 * 3
        setIcon("icon_time.png")
        setValueType(QjsValueType.activityTime.rawValue)
    }
}
