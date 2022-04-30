//
//  ChildsStackView.swift
//  Teremok-TV
//
//  Created by R9G on 13/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

protocol ChildsStackProtocol :AnyObject {
    func plusKids()
    func childClick(_ child: Child)
}

class ChildsStackView: UIStackView {
    
    weak var delegate: ChildsStackProtocol?
    
    @IBOutlet private var firstChild: AvatarButton!
    @IBOutlet private var secondChild: AvatarButton!
    @IBOutlet private var thirdChild: AvatarButton!
    
    @IBOutlet private var plusChild: AvatarButton!
    
    var childs: [Child] = []
    
    @IBAction func kidsPlusClick(_ sender: Any) {
        delegate?.plusKids()
    }
    @IBAction func firstClick(_ sender: Any) {
        if let ch = childs.first {
            delegate?.childClick(ch)
        }
    }
    @IBAction func secondClick(_ sender: Any) {
        if let ch = childs.second {
            delegate?.childClick(ch)
        }
    }
    @IBAction func thirdClick(_ sender: Any) {
        if let ch = childs[safe: 2] {
            delegate?.childClick(ch)
        }
    }
    
    func setAvatars(childs: [Child]){
        firstChild.isHidden = true
        secondChild.isHidden = true
        thirdChild.isHidden = true
		plusChild.isHidden = childs.count >= 3

        self.childs = childs
        if let first = childs.first {
            firstChild.setAvatar(linktoLoad: first.pic ?? "")
            firstChild.isHidden = false
        }
        if let second = childs.second {
            secondChild.setAvatar(linktoLoad: second.pic ?? "")
            secondChild.isHidden = false
            if let thChild = childs[safe: 2]  {
                thirdChild.setAvatar(linktoLoad: thChild.pic ?? "")
                thirdChild.isHidden = false
			}
        }
    }
}
