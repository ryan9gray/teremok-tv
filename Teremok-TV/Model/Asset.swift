
import Foundation

class Asset: DefaultsObject {
    var url: URL?
    var stream: Stream?

    init(url: URL, stream: Stream) {
        self.url = url
        self.stream = stream
    }

    required override init() {
        super.init()
    }
}


class Stream: DefaultsObject {
    var name: String?
    var id: Int?
    var playListURL: URL?
    var art: Data?

    init(playListURL: URL, name: String = "", art: Data? = nil, id: Int = 0) {
        self.name = name
        self.id = id
        self.playListURL = playListURL
    }
    required override init() {
        super.init()
    }
}
