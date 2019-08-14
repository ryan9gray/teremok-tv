//
//  CloudAlertViewController.swift
//  Teremok-TV
//
//  Created by R9G on 26/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import M13Checkbox

class CloudAlertViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var alertView: UIView!
    @IBOutlet private var doneBtn: UIRoundedButtonWithGradientAndShadow!
    
    var model: AlertModel?
    
    var complition: (() -> Void)?

    @IBAction func doneClick(_ sender: Any) {
        dismiss(animated: true) {
            self.complition?()
        }
    }
    
    @IBAction func fonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let alert = model else { return }
        
        titleLabel.text = alert.title
        descriptionLabel.text = alert.subtitle
        if let buttonTitle = alert.buttonTitle {
            doneBtn.setTitle(buttonTitle, for: .normal)
        }
    }

}
struct AlertModel {
    var title: String
    var subtitle: String
    var buttonTitle: String?

    init(title: String, subtitle: String, buttonTitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
    }
}

class AgreementViewController: CloudAlertViewController, UITextViewDelegate  {
    @IBOutlet private var checkbox: M13Checkbox!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkbox.boxType = .square
        checkbox.markType = .checkmark
        checkbox.tintColor = UIColor.View.yellow
        checkbox.checkState = .checked
        setAttrebute()
    }
    

    @IBAction func nextClick(_ sender: Any) {
        guard checkbox.checkState == .checked else {
            return
        }
        dismiss(animated: true) {
            self.complition?()
        }
    }
    
    @IBAction func switchCheckBox(_ sender: M13Checkbox) {
        //sender.toggleCheckState()

    }
    @IBOutlet private var textView: UITextView!

    func setAttrebute(){
        
        let text = "Для продолжения работы в приложении «Теремок-ТВ» необходимо ознакомиться с пользовательским соглашением."
        let attributedString = NSMutableAttributedString(string: text)
        
        let range = attributedString.mutableString.range(of: "пользовательским соглашением")
        attributedString.addAttribute(.link, value: "http://api.teremok.tv/static/agreement.html", range: range)
        
        textView.attributedText = attributedString
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}
