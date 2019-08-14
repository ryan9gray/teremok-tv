//
//  ScrollViewAlertViewController.swift
//  Teremok-TV
//
//  Created by R9G on 24/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class ScrollViewAlertViewController: UIViewController {

    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var doneBtn: UIRoundedButtonWithGradientAndShadow!
    @IBOutlet private var alertView: UIView!
    @IBOutlet private var descriptionTextView: UITextView!
    
    var model: AlertModel?

    
    var complition: (() -> Void)?
    
    @IBAction func crossClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClick(_ sender: Any) {
        dismiss(animated: true) {
            self.complition?()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alert = model else {
            return
        }
        
        titleLabel.text = alert.title
        descriptionTextView.text = alert.subtitle
        // Do any additional setup after loading the view.
    }

}
class InputAlertViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var doneBtn: UIRoundedButtonWithGradientAndShadow!
    @IBOutlet private var alertView: UIView!
    @IBOutlet private var codeTxtField: UITextField!

    var model: AlertModel?

    var complition: ((String) -> Void)?

    @IBAction func crossClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneClick(_ sender: Any) {
        dismiss(animated: true) {
            self.complition?(self.codeTxtField.text ?? "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alert = model else {
            return
        }

        titleLabel.text = alert.title
        doneBtn.setTitle(alert.subtitle, for: .normal)
    }

}
