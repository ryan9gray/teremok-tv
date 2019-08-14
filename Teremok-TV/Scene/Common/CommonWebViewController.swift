
import UIKit

class CommonWebViewController: AbstracViewController {
    
    @IBOutlet private var webView: UIWebView!

    var html: String?
    var url: URL?
    var activityView: LottieHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = LottieHUD()
        setupWebView()
    }
    
    private func setupWebView() {

        webView.backgroundColor = .white
        webView.autoresizingMask = .flexibleHeight
        webView.delegate = self
        if let url = url {
            loadURL(url)
            return
        }
        
        if let html = html { load(html) }
    }
    
    @IBAction func crossClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func load(_ html: String) {
        let htmlString = "<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>" +
            "<body style=\"font-family: Helvetica; font-size: 14; color: rgb(51,51,51)\">" +
            html + "</body>"
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func loadURL(_ url: URL) {
        activityView?.showHUD()
        webView.loadRequest(URLRequest(url: url))
    }
}
extension CommonWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView?.stopHUD()
    }
}
