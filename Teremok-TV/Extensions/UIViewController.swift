
import Foundation


import UIKit

extension UIViewController {
    static func instantiate(fromStoryboard storyboard: StoryboardWorker) -> Self {
        return storyboard.instantiateViewController(viewControllerClass: self)
    }
}
extension UIViewController {
    
    func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
}
extension UIViewController {
    
    @IBAction func dismissByTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    @IBInspectable var guPopUp: Bool {
        get {
            return (modalPresentationStyle == .custom) && self.isEqual(transitioningDelegate)
        }
        set {
            if newValue {
                modalPresentationStyle = .custom
                transitioningDelegate = self
            }
        }
    }
}

extension UIViewController {
    
    func child<T>() -> T? {
        if let result = children.first(where: { return $0 is T }) as? T {
            return result
        }
        return nil
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
enum StoryboardWorker: String {
    case autorization =         "Auth"
    case main =                 "Main"
    case play =                 "Play"
    case alerts =               "Alerts"
    case profile =              "Profile"
    case welcome =              "Welcome"
    case common =               "Common"
    case music =                "Music"
    case animals =              "Animals"
    case alphavite =            "Alphavite"
    case monster =             	"Monster"
    case colors =             	"ColorsGame"
	case puzzle =             	"Puzzle"

    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    func instantiateViewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        guard let vc = instance.instantiateViewController(withIdentifier: String(describing: viewControllerClass)) as? T else {
            fatalError("ViewController with identifier \(String(describing: viewControllerClass)), not found in \(rawValue)")
        }
        return vc
    }
}
