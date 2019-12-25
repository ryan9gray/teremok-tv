//
//  AvatarButton.swift
//  Teremok-TV
//
//  Created by R9G on 25/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class AvatarButton: RoundEdgeButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.borderColor = UIColor.View.yellowBase
        self.borderWidth = 5
        self.backgroundColor = .white
        clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
    }
    
    func setAvatar(_ image: UIImage?){
        if let im = image {
            setImage(im, for: .normal)
        }
        else {
            setImage(image, for: .normal)
        }
    }

    func setAvatar(linktoLoad: String){
        getImage(linktoLoad) { [weak self] image in
            if image != nil {
                self?.setAvatar(image)
            }
            else {
                self?.setAvatar(#imageLiteral(resourceName: "icUtka"))
            }
        }
    }

    func getImage(_ url: String, handler: @escaping (UIImage?) -> Void) {
        Alamofire.request(url, method: .get).responseImage { response in
            if let data = response.result.value {
                handler(data)
            } else {
                handler(nil)
            }
        }
    }

    func setupCurrent() {
        guard let childs = Profile.current?.childs else {
            isHidden = true
            return
        }

        if let avatarUrl = childs.first(where: { $0.current ?? false} )?.pic {
            setAvatar(linktoLoad: avatarUrl)
        }
    }
}
