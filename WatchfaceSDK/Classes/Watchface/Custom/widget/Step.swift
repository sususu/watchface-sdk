
import UIKit

public class Step: IconData {
    public override init() {
        super.init()
        initStep()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        initStep()
    }

    private func initStep() {
        setName("Step")
        // max value is 99999
        width = 20 * 5
        setIcon("icon_steps.png")
        setValueType(QjsValueType.stepsNum.rawValue)
    }
    
    public override func setIconAlign(_ align: Alignment) {
        super.setIconAlign(align)
        if align == .Left || align == .Right {
            width = 20 * 5 + 40
            height = 26
        } else {
            width = 20 * 5
            height = 26 + 40
        }
    }
}
