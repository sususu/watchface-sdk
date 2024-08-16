
import UIKit

class AppLinkWidget: ValueWidget {

    override init() {
        super.init()
        self.dependence = Dependence(module: "launcher", path: "launcher.js")
    }

    override func start() -> String {
        let name = "this.applink" + getJsVarName()
        // 创建
        var sb = ""
        sb += "\n"
        sb += "\t\t\(name) = new launcher(this.root());\n"
        sb += "\t\t\(name).set_pos(\(getLocation().x), \(getLocation().y));\n"
        sb += "\t\t\(name).set_size(\(getSize().width), \(getSize().height));\n"
        sb += "\t\t\(name).set_type(\(getValueType()));\n"
        return sb
    }
}
