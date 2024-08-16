
import UIKit

class GifSelectionWidget: ValueWidget {
    var gifs: [URL] = []
    var gifPaths: [String] = []
    var startDelay: Int = 400
    var playInterval: Int = 0
    var maxCount: Int = 0
    var loop: Bool = false
    var imagePrefix: String = ""

    override init() {
        super.init()
        self.dependence = Dependence(module: "idxanimimg", path: "idxanimimg.js")
    }

    override func start() -> String {
        let name = "this.gifoption" + getJsVarName()
        var sb = ""
        // 创建
        sb += "\n"
        sb += "\t\t\(name) = new idxanimimg(this.root());\n"
        sb += String(format: "\t\t%@.playback_mode(%d);\n", name, isLoop() ? 1 : 0)
        sb += "\t\t\(name).set_pos(\(getLocation().x), \(getLocation().y));\n"
        sb += "\t\t\(name).prefix(this.path() + \"\(getImagePrefix())\", \(getMaxCount()));\n"

        if getValueType() >= 0 {
            // 绑定数据
            let index_name = "this.gpe_" + getJsVarName()
            // 初始化值
            sb += String(format: "\t\t%@ = lv.app_db_get_val_enum(%d);\n", index_name, getValueType())
            sb += String(format: "\t\t%@.select(%@);\n", name, index_name)
            sb += String(format: "\t\t%@.anim_open(%d, %d);\n", name, getStartDelay(), getPlayInterval())
            // 绑定数据
            sb += String(format: "\t\t%@.bind(%d, function(idx, val)", name, getValueType())
            sb += " {\n"
            sb += String(format: "\t\t\t%@ = lv.app_db_get_val_enum(%d);\n", index_name, getValueType())
            sb += String(format: "\t\t\t%@.select(%@);\n", "this", index_name)
            sb += "\t\t});\n"
        }
        return sb
    }

    override func pause() -> String {
        let name = "this.gifoption" + getJsVarName()
        return "\t\t\(name).anim_pause();\n"
    }

    override func resume() -> String {
        let name = "this.gifoption" + getJsVarName()
        let index_name = "this.gpe_" + getJsVarName()
        var sb = ""
        // 初始化值
        sb += String(format: "\t\t%@ = lv.app_db_get_val_enum(%d);\n", index_name, getValueType())
        sb += String(format: "\t\t%@.select(%@);\n", name, index_name)
        sb += "\t\t\(name).anim_resume();\n"
        return sb
    }

    override func stop() -> String {
        let name = "this.gifoption" + getJsVarName()
        return "\t\t\(name).anim_close();\n"
    }

    func getStartDelay() -> Int {
        return startDelay
    }

    func setStartDelay(_ startDelay: Int) {
        self.startDelay = startDelay
    }

    func getPlayInterval() -> Int {
        return playInterval
    }

    func setPlayInterval(_ playInterval: Int) {
        self.playInterval = playInterval
    }

    func getMaxCount() -> Int {
        return maxCount
    }

    func setMaxCount(_ maxCount: Int) {
        self.maxCount = maxCount
    }

    func isLoop() -> Bool {
        return loop
    }

    func setLoop(_ loop: Bool) {
        self.loop = loop
    }

    func getImagePrefix() -> String {
        return imagePrefix
    }

    func setImagePrefix(_ imagePrefix: String) {
        self.imagePrefix = imagePrefix
    }

    func getGifs() -> [URL] {
        return gifs
    }

    func setGifs(_ gifs: [URL]) {
        self.gifs = gifs
    }

    func getGifPaths() -> [String] {
        return gifPaths
    }

    func setGifPaths(_ gifPaths: [String]) {
        self.gifPaths = gifPaths
    }
}
