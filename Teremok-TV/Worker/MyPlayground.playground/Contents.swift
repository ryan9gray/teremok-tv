//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]

            let string = "How much wood would a woodchuck\nchuck if a woodchuck would chuck wood?"
            string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        let imageview = UIImageView()
        imageview.frame = CGRect(x: 150, y: 200, width: 448, height: 448)
        imageview.image = img
        view.addSubview(imageview)

    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
