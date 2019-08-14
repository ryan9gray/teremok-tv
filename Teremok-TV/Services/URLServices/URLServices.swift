//
//  URLServices.swift
//  gu
//
//  Created by NRokudaime on 03.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

protocol URLServices {
    func open(link: AppURL) -> Bool
    func open(link: String) -> Bool
    func open(url: URL) -> Bool
}

enum AppURL: String {
    case main = ""

}
