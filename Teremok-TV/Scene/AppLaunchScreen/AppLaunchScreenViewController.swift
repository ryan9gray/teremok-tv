//
//  AppLaunchScreenViewController.swift
//  Teremok-TV
//
//  Created by R9G on 17/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Lottie

protocol AppLaunchScreenDisplayLogic: CommonDisplayLogic {
    
}

class AppLaunchScreenViewController: UIViewController, AppLaunchScreenDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: AppLaunchScreenBusinessLogic?
    var router: (NSObjectProtocol & AppLaunchScreenRoutingLogic & AppLaunchScreenDataPassing & CommonRoutingLogic)?

    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    // MARK: Object lifecycle

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
        let interactor = AppLaunchScreenInteractor()
        let presenter = AppLaunchScreenPresenter()
        let router = AppLaunchScreenRouter()
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

    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //finish()
//        DispatchQueue.main.asyncAfter(deadline: .now()+8) {
//            self.finish()
//        }
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(again))
//        self.view.addGestureRecognizer(tap)
        start()
    }
    
    // MARK: Do something
    
    @objc func again(){
        self.animationView?.removeFromSuperview()
        self.animationView = nil
        start()
    }
    
    func start(){
        setAnimation(file: AppLaunchScreen.Animation.finish.rawValue)
        
        animationView?.play(completion: { (isFinish) in
            if isFinish {
                print("finish animation")
                self.animationView?.removeFromSuperview()
                self.animationView = nil
                self.loop()
            }
        })
    }
    
    func loop(){
        animationView = AnimationView(name: AppLaunchScreen.Animation.loop.rawValue)
        guard let av = animationView else { return }
        av.frame = view.bounds
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFill
        av.loopMode = .loop
        av.animationSpeed = 1.0
        self.view.addSubview(av)
        av.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.finish()
        }
    }
    func finish(){
        self.animationView?.removeFromSuperview()
        self.animationView = nil
        setAnimation(file: AppLaunchScreen.Animation.finish.rawValue)
        animationView?.play(fromProgress: 1, toProgress: 0, completion: { (finish) in
            ViewHierarchyWorker.setRootViewController(rootViewController: MasterViewController.instantiate(fromStoryboard: .main))
            self.dismiss(animated: true, completion: nil)
        })
//        animationView?.play(completion: { (finish) in
//            ViewHierarchyWorker.setRootViewController(rootViewController: MasterViewController.instantiate(fromStoryboard: .main))
//            self.dismiss(animated: true, completion: nil)
//        })
    }
    
    private func setAnimation(file: String){
        //guard animationView == nil else { return }
        animationView = AnimationView(name: file)
        guard let av = animationView else { return }
        av.frame = view.bounds
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFill
        av.loopMode = .playOnce
        av.animationSpeed = 1.0
        self.view.addSubview(av)
        
    }
}
