//
//  RegistrationViewController.swift
//  Teremok-TV
//
//  Created by R9G on 10.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegistrationDisplayLogic: CommonDisplayLogic {
    func goToChild()
}

class RegistrationViewController: AbstracViewController, RegistrationDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: RegistrationBusinessLogic?
    var router: (NSObjectProtocol & RegistrationRoutingLogic & RegistrationDataPassing & CommonRoutingLogic)?

    @IBOutlet private var passTxtField: UITextField!
    @IBOutlet private var emailTxtField: UITextField!
    @IBOutlet private var signInBtn: OrangeButton!
    @IBOutlet private var missBtn: UIButton!
    @IBOutlet private var backBtn: UIButton!

    // MARK: Object lifecycle
      
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter()
        let router = RegistrationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn.isHidden = !(masterRouter?.canPop() ?? false)
        missBtn.isHidden = false
    }

    @IBAction func authTap(_ sender: Any) {
        router?.routAuth()
    }
    @IBAction func backClick(_ sender: Any) {
        masterRouter?.popChild()
    }
    @IBAction func saveClick(_ sender: UIButton) {
        register()
    }
    
    @IBAction func missClick(_ sender: Any) {
        masterRouter?.pushChild(viewControllerClass: MainViewController.self, storyboard: .main)
    }

    private func register(){
        guard interactor?.validatePassFields(text: passTxtField.text ?? "") ?? false else {
            return
        }
        interactor?.checkEmail(email: emailTxtField.text ?? "")
    }
    
    func goToChild(){
        router?.navigateToChild(email: emailTxtField.text ?? "", pass: passTxtField.text ?? "")
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField {
            passTxtField.becomeFirstResponder()
        } else {
            register()
        }
        return true
    }
}
