//
//  PuzzleMasterModels.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright (c) 2020 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PuzzleMaster {
    // MARK: Use cases
	struct Puzzle {
		let imageLink: String
	}

	static let mock: [Puzzle] = [
		Puzzle(imageLink: "https://i.pinimg.com/originals/98/6a/c3/986ac391b218a3a9ad750441e8cf1e42.jpg")
	]
}
