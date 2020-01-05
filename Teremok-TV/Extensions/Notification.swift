//
//  Notification.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let BadgeValueChanged = Notification.Name(rawValue: "BadgeValueChanged")
    public static let BadgeDidRecivePush = Notification.Name(rawValue: "BadgeDidRecivePush")
    public static let ProfileDidChanged: NSNotification.Name = NSNotification.Name(rawValue: "ProfileDidChanged")
    public static let ProfileNeedReload: NSNotification.Name = NSNotification.Name(rawValue: "ProfileNeedReload")
    public static let UploadProgress = Notification.Name("UploadProgress")
    public static let AchievmentBadge = Notification.Name("AchievmentBadge")
    public static let FavBadge = Notification.Name("FavBadge")
    public static let MusicBadge = Notification.Name("MusicBadge")
    public static let Internet = Notification.Name("Internet")
    public static let SwichTrack = Notification.Name("SwichTrack")
}
