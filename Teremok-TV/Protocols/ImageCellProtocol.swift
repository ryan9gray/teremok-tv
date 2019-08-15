//
//  CellProtocol.swift
//  Geek-TV
//
//  Created by Ryan9Gray on 04.01.2018.
//  Copyright © 2018 DoubleDevTeam. All rights reserved.
//

import Foundation
import AlamofireImage

protocol ImageCellProtocol {

    var linktoLoad : String {get set}
    func setImage()
}

extension ImageCellProtocol where Self : PreviewImageCollectionViewCell {
    
    func setImage() {
        if linktoLoad != ""{
            let downloadURL = URL(string: linktoLoad)!
            self.imageView.af_setImage(
                withURL: downloadURL,
                placeholderImage: #imageLiteral(resourceName: "icNowifi"),
                filter: nil,
                imageTransition: .crossDissolve(0.5),
                completion: nil)
        }
    }
}
