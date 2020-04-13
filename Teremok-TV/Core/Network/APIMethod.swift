
import Foundation

enum APIMethod {
    enum Users: String, ServiceMethod  {
        case createSession
        case userRegistration
        case userEdit
        case checkEMail
        case restorePasswordQuery
        case restorePassword
        case resetPassword
        case auth
        case logout
        case checkCode
        
        var controller: APIController {
            return .users
        }
    }
    enum Profile: String, ServiceMethod  {
        case addChild
        case switchChild
        case uploadUserPic
        case getProfile
        case deleteChild
        case editChild
        case getFavorites
        case getAchievements
        
        var controller: APIController {
            return .profile
        }
    }
    enum Content: String, ServiceMethod  {
        case main
        case razd
        case videos
        case videoItem
        case catalog
        case search
        case searchByKeywords
        
        var controller: APIController {
            return .content
        }
    }
    enum Actions: String, ServiceMethod  {
        case viewVideo
        case downloadVideo
        case likeVideo
        case favVideo
        case downloadsSync
        
        var controller: APIController {
            return .actions
        }
    }
    enum Purchase: String, ServiceMethod  {
        case iosSubscription
        case activatePromoCode
        case getPromoCode

        var controller: APIController {
            return .purchase
        }
    }
    enum Music: String, ServiceMethod  {
        case main
        case playlist
        case search
        case searchVars
        case favTrack
        case downloadsSync
        case downloadTrack
        case listenTrack

        var controller: APIController {
            return .music
        }
    }
    enum AnimalsGame: String, ServiceMethod  {
        case listPacks
        case getPack
        case getStat
        case sendStat

        var controller: APIController {
            return .animalsGame
        }
    }
    enum Analytic: String, ServiceMethod  {
        case eventsLog

        var controller: APIController {
            return .analytic
        }
    }
    enum AlphabetGame: String, ServiceMethod  {
        case getStat
        case sendStat

        var controller: APIController {
            return .alphabetGame
        }
    }
    enum MonstersGame: String, ServiceMethod {
        case getStat
        case sendStat
        
        var controller: APIController {
            return .monstersGame
        }
    }
    enum ColorsGame: String, ServiceMethod  {
        case getStat
        case sendStat

        var controller: APIController {
            return .colorsGame
        }
    }
    enum DinosaursGame: String, ServiceMethod {
        case getStat
        case sendStat
        
        var controller: APIController {
            return .dinosaursGame
        }
    }
}

protocol ServiceMethod {
    var controllerName: String { get } // имя контроллера емп profile, auth и т.д.
    var version: String { get } // версия контроллера - default "1.0"
    var methodName: String { get } // сокращенное имя метода без версии - profile/get
    var fullMethodName: String { get } // полное имя метода с версией - v1.0/profile/get
    var controller: APIController { get } // тип контроллера
    static func getMethods() -> [String]
}

extension ServiceMethod where Self: RawRepresentable, Self: Hashable {
    
    var controllerName: String {
        return controller.rawValue
    }
    
    var version: String {
        return "1"
    }
    
    var methodName: String {
        return "\(controllerName)/\(self)"
    }
    
    var fullMethodName: String {
        return "v\(version)/\(methodName)"
    }
    
    static func getMethods() -> [String] {
        return allValues().compactMap({ $0.fullMethodName })
    }
}

enum APIController: String {
    case users
    case profile
    case content
    case actions
    case purchase
    case music
    case animalsGame
    case analytic
    case alphabetGame
    case monstersGame
    case dinosaursGame
    case colorsGame

    var methodType: ServiceMethod.Type {
        switch self {
            case .users: return APIMethod.Users.self
            case .profile: return APIMethod.Profile.self
            case .content: return APIMethod.Content.self
            case .actions: return APIMethod.Actions.self
            case .purchase: return APIMethod.Purchase.self
            case .music: return APIMethod.Music.self
            case .animalsGame: return APIMethod.AnimalsGame.self
            case .analytic: return APIMethod.Analytic.self
            case .alphabetGame: return APIMethod.AlphabetGame.self
            case .monstersGame: return APIMethod.MonstersGame.self
            case .dinosaursGame: return APIMethod.DinosaursGame.self
            case .colorsGame: return APIMethod.ColorsGame.self
        }
    }
    
    var version: String {
        return "1"
    }
}
