//
//  SerialDescriptionViewController.swift
//  Teremok-TV
//
//  Created by R9G on 25/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

protocol DescriptionVCProtocol: class {
    func toWatch(_ sender: Any)
}
protocol DescriptionSerialVCProtocol: DescriptionVCProtocol {
    func forward(_ sender: Any)
    func previous(_ sender: Any)
}


class DescriptionViewController: UIViewController {

    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var descriptionTxt: UITextView!
    

 
    @IBAction func fonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var farwardBtn: UIButton!
    @IBOutlet private var doneBtn: UIRoundedButtonWithGradientAndShadow!

    @IBAction func crossClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollIndicatorColor(color: UIColor.View.yellowBase)
        // Do any additional setup after loading the view.
    }
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.descriptionTxt.subviews {
            if view is UIImageView,
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                
                imageView.tintColor = color
                imageView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
    }

}
class SerialDescriptionViewController: DescriptionViewController {

    var item: Serial.Item?
    
    private func setUp(item: Serial.Item){
        titleLbl.text = item.name
        descriptionTxt.text = item.description
        
    }
    weak var delegate: DescriptionSerialVCProtocol?
    @IBAction func watchClick(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.toWatch(self)
        }
    }
    @IBAction func backClick(_ sender: Any) {
        delegate?.previous(self)
    }
    @IBAction func farwardClick(_ sender: Any) {
        delegate?.forward(self)
    }
    func reload(){
        guard let item = self.item else {
            return
        }
        setUp(item: item)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = self.item else {
            return
        }
        setUp(item: item)
        // Do any additional setup after loading the view.
    }
    
    
}
class RazdelDescriptionViewController: DescriptionViewController {
    
    var item: RazdelVCModel.SerialItem?
    
    private func setUp(item: RazdelVCModel.SerialItem){
        titleLbl.text = item.name
        descriptionTxt.text = item.description
        
    }
    @IBAction func watchClick(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.toWatch(self)
        }
    }
    weak var delegate: DescriptionVCProtocol?

    func reload(){
        guard let item = self.item else {
            return
        }
        setUp(item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = self.item else {
            return
        }
        setUp(item: item)
        // Do any additional setup after loading the view.
    }
    
    
}
