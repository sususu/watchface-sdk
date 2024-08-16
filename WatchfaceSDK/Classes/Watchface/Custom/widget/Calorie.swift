
import UIKit

public class Calorie: IconData {
    public override init() {
        super.init()
        initCalorie()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        initCalorie()
    }

    private func initCalorie() {
        setName("Calorie")
        // max value is 9999
        width = 20 * 4
        setIcon("icon_kcal.png")
        setValueType(QjsValueType.calorieNum.rawValue)
    }
}
