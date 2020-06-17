//
//  NibLoadable.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 08.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class NibLoadableView: UIView {
    @IBOutlet private var nibContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed(nibClassName, owner: self, options: nil)
        nibContentView.frame = bounds
        addSubview(nibContentView)
    }
}

extension NSObject {
    
    var nibClassName: String {
        return String(describing: type(of: self))
    }
    
    class var nibClassName: String {
        return String(describing: self)
    }
}
