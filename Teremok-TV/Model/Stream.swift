
import Foundation

class Stream: DefaultsObject {
    var url: URL? = nil
    var name: String = ""
    var art: Data? = nil
    var id: Int = 0

    public init(url: URL? = nil, name: String = "", art: Data? = nil, id: Int = 0) {
        self.url = url
        self.name = name
        self.art = art
        self.id = id
    }

    required override init() {
        super.init()
    }
}

