
import Foundation

class Stream: DefaultsObject {
    let url: URL
    let name: String
    let art: Data?
    let id: Int

    public init(url: URL, name: String, art: Data?, id: Int) {
        self.url = url
        self.name = name
        self.art = art
        self.id = id
    }

    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

