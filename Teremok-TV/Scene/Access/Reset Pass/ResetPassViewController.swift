//
//  ResetPassViewController.swift
//  Teremok-TV
//
//  Created by R9G on 15/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Spring

protocol ResetPassDisplayLogic: CommonDisplayLogic, UITextFieldDelegate {
    var screen: ResetPass.Screen { get set }
    func switchScreen(_ screen: ResetPass.Screen)
    func done()
}

class ResetPassViewController: AbstracViewController, ResetPassDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: ResetPassBusinessLogic?
    var router: (NSObjectProtocol & ResetPassRoutingLogic & ResetPassDataPassing & CommonRoutingLogic)?

    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    // MARK: Object lifecycle


    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var codeFld: UITextField!
    @IBOutlet private var codeView: DesignableView!
    @IBOutlet private var mailView: DesignableView!
    @IBOutlet private var passField: UITextField!
    @IBOutlet private var passCheckField: UITextField!
    @IBOutlet private var emailFld: UITextField!
    @IBOutlet private var newPassView: DesignableView!
    @IBOutlet private var newPassCheckView: DesignableView!
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var resetBtn: OrangeButton!

    var screen = ResetPass.Screen.Email
    private let maxLength = 4


    @IBAction func resetClick(_ sender: UIButton) {
        switch screen {
        case .Pass:
            sendPass()
        case .Email:
            sendByEmail()
        case .Code:
            break
        }
    }

    @IBAction func backClick(_ sender: Any) {
        router?.pop()
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
        let interactor = ResetPassInteractor()
        let presenter = ResetPassPresenter()
        let router = ResetPassRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    func setUI(){
        backBtn.isHidden = !(masterRouter?.canPop() ?? false)
        activityView = LottieHUD()
        //hideKeyboardWhenTappedAround()
    }

    func done(){
        hidePreloader()
        router?.navigateToAuth()
    }

    func checkCode(_ code: String){
        showPreloader()
        interactor?.sendCode(code)
    }

    func sendByEmail(){
        guard let email = emailFld.text, !email.isEmpty else {
            return
        }
        showPreloader()
        interactor?.sendEmail(email)
    }

    func sendPass(){
        guard
            let pass = passField.text,
            let checkPass = passCheckField.text,
            !pass.isEmpty
        else { return }

        guard  pass == checkPass else {
            present(errorString: "Пароли не совпадают", completion: nil)
            return
        }

        showPreloader()
        interactor?.sendPass(pass)
    }

    func switchScreen(_ screen: ResetPass.Screen){
        self.screen = screen
        hidePreloader()
        switch screen {
        case .Pass:
            titleLbl.text = "Введите новый пароль"
            mailView.isHidden = true
            newPassView.isHidden = false
            newPassCheckView.isHidden = false
            codeView.isHidden = true
            resetBtn.isHidden = false
        case .Email:
            titleLbl.text = "Восстановление пароля"
            mailView.isHidden = false
            newPassView.isHidden = true
            newPassCheckView.isHidden = true
            codeView.isHidden = true
            resetBtn.isHidden = false
        case .Code:
            titleLbl.text = "Введите код"
            mailView.isHidden = true
            newPassView.isHidden = true
            newPassCheckView.isHidden = true
            codeView.isHidden = false
            resetBtn.isHidden = true
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == maxLength {
            checkCode(newString as String)
        }
        return newString.length <= maxLength
    }
}
