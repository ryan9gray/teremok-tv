
import Foundation

class AppLaunchInfoDefaults: DefaultsObject {
    var appVersion: String? = AppInfoWorker.applicationVersion()
    // для текущей версии версии приложения
    var firstAppLaunchDate: Date?
    var launchesCount: Int = 0
    
    required override init() {
        super.init()
    } 
}
class HLSAssets: DefaultsObject {
    var streams: [Asset] = []

    required override init() {
        super.init()
    }
}
