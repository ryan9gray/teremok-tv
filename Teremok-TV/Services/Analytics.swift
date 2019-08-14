//
//  Analytics.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 20/07/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation
import Trackable
import ObjectMapper
import UIKit

let analytics: Analitics & TrackableClass = AnalyticsService()

protocol Analitics {
    func updatedEvent()
}

class AnalyticsService: Analitics {
    private let startTime = Date()
    private var log: AnaliticModel
    private var lastSend = LocalStore.analiticsLastSend


    init() {
        log = AppCacher.mappable.getObject(of: AnaliticModel.self) ?? AnaliticModel(event: "", argument: "")
        Trackable.trackEventToRemoteServiceClosure = trackEventToBackend
        Trackable.eventPrefixToRemove = "TrackableExample.Events."
        Trackable.keyPrefixToRemove = "TrackableExample.Keys."
        setupTrackableChain() // allows self to be part of the trackable chain
    }

    func trackEventToBackend(_ eventName: String, trackedProperties: [String: AnyObject]) {
        // We want to also print the event and arguments to console.
        // (arguments will be in alphabetical order)
        let listOfArguments = trackedProperties.sorted(by: { $0.0 < $1.0 }).reduce("") { (finalString, element) -> String in
            return finalString + "\(element.0): \(element.1)\n"
        }
        print("\n---------------------------- \nEvent: \(eventName)\n\(listOfArguments)--------------")

        if lastSend == 0 {
            lastSend  = Date().timeIntervalSince1970
            LocalStore.analiticsLastSend = lastSend
        }

        log.events[eventName] = listOfArguments
        let interval = TimeInterval(lastSend) - Date().timeIntervalSince1970
        if  interval > CacheExpiration.day || log.events.count > 30 {
            send()
            return
        }
        AppCacher.mappable.saveObject(log)
    }

    // MARK: Events

    func updatedEvent() {
        track(Events.User.updated)
    }

    func send() {
        sendLogs(log.events) { [weak self] result in
            switch result {
            case .success(let status):
                print(status.status)
                LocalStore.analiticsLastSend = Date().timeIntervalSince1970
                self?.log = AnaliticModel(event: "", argument: "")
                AppCacher.mappable.removeValue(of: AnaliticModel.self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }

    func sendLogs(_ logs: [String: String], completion: @escaping (Result<StatusResponse>) -> Void) {
        EventsLogCommand(events: logs).execute(success: { responseObject in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}

extension AnalyticsService : TrackableClass {
    // Since the analytics object is a parent for all other TrackableClasses in the project,
    // these properties will be added to all events.
    // Notice the + operator. You can use it for merging sets of TrackedProperty: Set<TrackedProperty> + Set<TrackedProperty>
    var trackedProperties: Set<TrackedProperty> {
        return [Keys.App.uptime ~>> NSDate().timeIntervalSince(startTime), Keys.App.currrentDate ~>> Date().longDateAndTime]
    }
}

enum Events {

    enum User: String, Event {
        case updated
    }

    enum Store: String, Event {
        case PurchaseTap
        case Purchased
        case RestoreTap
    }

    enum Time: String, Event {
        case AnimalFlow
        case AlphabetFlow

        case MusicFlow
        case Razdel
        case Video
    }

    enum VideoFlow: String, Event {
        case RecommendationTap
        case VideoEnd
    }

    enum App: String, Event {
        case started
        case didBecomeActive
        case didEnterBackground
        case terminated
    }
}

enum Keys: String, Key {
    case Identifier
    case Timer
    case Video

    enum App: String, Key {
        case uptime
        case currrentDate
        case launchTime
    }
}

class AnaliticModel: Mappable {

    var events: [String: String] = [:]

    required init?(map: Map) { }

    init(event: String, argument: String) {
        events[event] = argument
    }
    func mapping(map: Map) {
        events <- map["events"]
    }
}
