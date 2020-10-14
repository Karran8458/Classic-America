//
//  WebViewViewController.swift
//  VtronixApp
//
//  Created by samstag on 30.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import WebKit


class WebViewNavigationController: UINavigationController {
    
    init(url: URL, title: String? = nil) {
        
        let wvvc = WebViewViewController.init(url: url)
        wvvc.title = title

        super.init(rootViewController: wvvc)
        
        self.applySharedNavigationBarStyle()

        wvvc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Close",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(self.btnCloseTapped(_:)))

    }
    
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    @objc func btnCloseTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}


class WebViewViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var url: URL
    
    
    init(url: URL, nibNameOrNil: String? = nil) {
        
        self.url = url
        
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.applySharedNavigationBarStyle()
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.webView.navigationDelegate = self
        let request = URLRequest.init(url: self.url)
        self.webView.load(request)
    }
    
}


extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.activityIndicator.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.activityIndicator.stopAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        self.activityIndicator.stopAnimating()
    }
    
}
