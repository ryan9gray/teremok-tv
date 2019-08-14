

import UIKit
import ObjectMapper

class RequestCacheCleaner {
    enum Cacheable {
        case widgetGet

        
        var command: CacheableCommand.Type {
            switch self {
            //case .widgetGet: return WidgetGetCommand.self

            case .widgetGet:
                return CacheableCommand.self
            }
        }
    }
    
    static func clearCache(_ cacheable: RequestCacheCleaner.Cacheable) {
        cacheable.command.removeCache()
    }
    
    static func clearCache(_ cacheables: [RequestCacheCleaner.Cacheable]) {
        for cacheable in cacheables {
            clearCache(cacheable)
        }
    }
}

extension RequestCacheCleaner {
    static func clearWidgetsCache(with userInfo: [AnyHashable : Any]) {
        if let push = Mapper<TTPush>().map(JSONObject: userInfo) {
            clearWidgetsCache(with: push)
        }
    }
    
    static func clearWidgetsCache(with push: TTPush) {
        switch push.action {
        case .unknown:
            //RequestCacheCleaner.clearCache([.epdGet, .widgetGet])
            break
        default:
            break
        }
    }
}
