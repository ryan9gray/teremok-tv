//
//  GUImageBadgeBarItem.swift
//  gu
//
//  Created by Армен Алумян on 16.07.2018.
//  Copyright © 2018 altarix. All rights reserved.
//
import UIKit


class BadgeButton: TTAbstractMainButton {
    
    var badgeLabel = UILabel()
    
    var badge: Int = 0 {
        didSet {
            //addbadgetobutton(badge: badge)
        }
    }
    
    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        addbadgetobutton(badge: nil)
    }

    
    func addbadgetobutton(badge: Int?) {
        guard let count = badge, count > 0 else {
            self.badge = 0
            badgeLabel.isHidden = true
            return
        }
        self.badge += count
        badgeLabel.text = count.stringValue
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) + horizontal!)
            let y = (Double(badgeSize.height) / 2) + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
