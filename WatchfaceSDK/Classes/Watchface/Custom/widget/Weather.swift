
import UIKit

public class Weather: IconData {
    public override init() {
        super.init()
        initWeather()
    }

    public override init(tintColor: UIColor) {
        super.init(tintColor: tintColor)
        initWeather()
    }

    private func initWeather() {
        setName("Weather")
        // max value is 999
        width = 20 * 3
        setIcon("icon_weather.png")
        setValueType(QjsValueType.temperatureNum.rawValue)
    }
}

