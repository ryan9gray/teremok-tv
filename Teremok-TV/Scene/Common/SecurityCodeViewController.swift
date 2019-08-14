//
//  SecurityCodeViewController.swift
//  Teremok-TV
//
//  Created by R9G on 21/11/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class SecurityCodeViewController: AbstracViewController {
    
    @IBOutlet private var numberLbl: UILabel!
    
    @IBOutlet private var codeTxtField: UITextField!
    
    @IBAction func doneClick(_ sender: Any) {
        cheack()
    }
    
    var codes: [Int] = []
    
    enum Screen {
        case settings
        case store
    }
    var screen: Screen = .settings
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateCode()
    }

    func generateCode(){
        codes = makeList(4)
        let stringNumbers = codes.map({$0.stringNumber()}).joined(separator: ", ")
        numberLbl.text = "Введите в поле - " + stringNumbers
        if ServiceConfiguration.activeConfiguration() == .sandbox  {
            codeTxtField.text = codes.map { $0.stringValue }.joined()
        }
    }

    func cheack(){
        let stringNumbers = codes.map{$0.stringValue}
        if codeTxtField.text == stringNumbers.joined() {
            done()
        }
    }
    
    func done(){
        switch self.screen {
        case .settings:
            let settings = SettingsViewController.instantiate(fromStoryboard: .main)
            self.masterRouter?.pushChild(settings)
        case .store:
            let settings = StoreViewController.instantiate(fromStoryboard: .main)
            self.masterRouter?.pushChild(settings)
        }
    }
    
    func makeList(_ n: Int) -> [Int] {
        return (0..<n).map{ _ in Int(arc4random_uniform(9) + 1) }
    }
}
