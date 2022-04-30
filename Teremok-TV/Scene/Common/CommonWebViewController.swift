
import UIKit
import WebKit

class CommonWebViewController: AbstracViewController {
    
    @IBOutlet private var webView: WKWebView!

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
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.configuration.dataDetectorTypes = .link
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // webView.delegate = self
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
        webView.load(URLRequest(url: url))
    }
}
extension CommonWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView?.stopHUD()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView?.stopHUD()
    }
}
