
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
