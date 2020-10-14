//
//  PDFWebViewViewController.swift
//  VtronixApp
//
//  Created by samstag on 6.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


class PDFWebViewNavigationController: WebViewNavigationController {
    
    init(data: (pdfURL: URL, productURL: URL?), title: String? = nil) {
        
        let wvvc = PDFWebViewViewController.init(data: data)
        wvvc.title = title
        
        super.init(rootViewController: wvvc)
        
        self.applySharedNavigationBarStyle()

        wvvc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Close",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(self.btnCloseTapped(_:)))
    }
    
    
    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
}


class PDFWebViewViewController: WebViewViewController {
    
    var productURL: URL?
    
    
    init(data: (pdfURL: URL, productURL: URL?)) {
        
        self.productURL = data.productURL
        
        super.init(url: data.pdfURL, nibNameOrNil: "PDFWebViewViewController")
    }
    
    
    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    @IBAction private func btnBuyTapped(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        if let productURL = self.productURL {
            UIApplication.shared.open(productURL, options: [:]) { [weak self] (_) in
                self?.activityIndicator.stopAnimating()
            }
        } else {
            let vc = RequestProductViewController.init(productName: self.title ?? "")
            let navVC = UINavigationController.init(rootViewController: vc)
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction private func btnDownloadTapped(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        let avc = UIActivityViewController.init(activityItems: [self.url] , applicationActivities: nil)
        self.present(avc, animated: true) { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
