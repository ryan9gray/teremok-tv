
import Foundation

class Asset: DefaultsObject {
    var url: URL?
    var stream: Stream?
    var bookmark: Data?

    init(url: URL, stream: Stream) {
        self.url = url
        self.stream = stream
    }

    required override init() {
        super.init()
    }
}


class Stream: DefaultsObject {
    var name: String? = ""
    var streamID: Int = 0
    var playListURL: URL?
    var art: Data?

    init(playListURL: URL, name: String, art: Data?, id: Int) {
        self.name = name
        self.streamID = id
        self.playListURL = playListURL
        self.art = art
    }
    required override init() {
        super.init()
    }
}
