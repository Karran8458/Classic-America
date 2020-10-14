//
//  ProductViewController.swift
//  VtronixApp
//
//  Created by samstag on 30.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import MBProgressHUD


class ProductViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var btnProductSpecs: UIButton!
    @IBOutlet var btnProductDiagram: UIButton!
    @IBOutlet var btnBuyProduct: UIButton!
    
    var product: Product
    
    lazy var hud: MBProgressHUD = {
        let mbph = MBProgressHUD(view: self.view)
        self.view.addSubview(mbph)
        return mbph
    }()
    
    
    init(product: Product) {
        
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.applySharedNavigationBarStyle()
        
        self.title = self.product.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "shopping-cart"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(self.buyProductTapped(_:)))
        
        self.scrollView.delaysContentTouches = false

        self.imageView.layer.cornerRadius = 8.0
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        self.imageView.contentMode = .scaleAspectFit

        self.activityIndicator.hidesWhenStopped = true

        self.titleLabel.font = UIFont.appFontMedium(ofSize: 24.0)
        self.titleLabel.textColor = .darkGray

        self.subtitleLabel.font = UIFont.appFontLight(ofSize: 18.0)
        self.subtitleLabel.textColor = .darkGray
        
        self.setContentWith(product: self.product)
        
        self.applyButtonStyle(to: self.btnProductSpecs)
        self.applyButtonStyle(to: self.btnProductDiagram)
        self.applyButtonStyle(to: self.btnBuyProduct)

        self.btnProductSpecs.addTarget(self, action: #selector(self.productSpecsTapped(_:)), for: .touchUpInside)
        self.btnProductDiagram.addTarget(self, action: #selector(self.productDiagramTapped(_:)), for: .touchUpInside)
        self.btnBuyProduct.addTarget(self, action: #selector(self.buyProductTapped(_:)), for: .touchUpInside)
    }
    
    
    private func setContentWith(product pr: Product) {
        
        if  let strUrl = pr.image,
            let url = URL(string: strUrl)
        {
            self.activityIndicator.startAnimating()
            self.imageView.kf.setImage(with: url,
                                       placeholder: nil,
                                       options: nil,
                                       progressBlock: nil)
            { [weak self] (result) in
                self?.activityIndicator.stopAnimating()
            }
        }
        else
        {
            self.activityIndicator.stopAnimating()
        }
        self.titleLabel.text = pr.name
        self.subtitleLabel.text = pr.description
    }
    
    
    // MARK: IB Actions (selectors)
    
    @objc private func buyProductTapped(_ sender: Any) {

        self.hud.show(animated: true)
        
        if self.product.url == "" {
            let vc = RequestProductViewController.init(productName: self.product.name ?? "")
            let navVC = UINavigationController.init(rootViewController: vc)
            self.present(navVC, animated: true) { [weak self] in
                self?.hud.hide(animated: true)
            }
        } else {
            self.sanitizeURLOrDisplayError(fromString: self.product.url) { [weak self] (url) in
                UIApplication.shared.open(url, options: [:]) { (_) in
                    self?.hud.hide(animated: true)
                }
            }
        }
    }
    

    @objc private func productSpecsTapped(_ sender: Any) {
        
        self.hud.show(animated: true)
        
        let productURL = URL(string: self.product.url ?? "")
        let productName = self.product.name
        self.sanitizeURLOrDisplayError(fromString: self.product.specsUrl, success: { [weak self] (specsURL) in
            
            let data = (pdfURL: specsURL, productURL: productURL)
            let wvnvc = PDFWebViewNavigationController.init(data: data, title: productName)
            wvnvc.modalPresentationStyle = .fullScreen
            
            self?.present(wvnvc, animated: true) {
                self?.hud.hide(animated: true)
            }
        })
    }
    
    
    @objc private func productDiagramTapped(_ sender: Any) {
        
        self.hud.show(animated: true)
        
        let commonBlock: ((String?, URL?) -> Void) = { [weak self] (productName, productURL) in
            self?.sanitizeURLOrDisplayError(fromString: self?.product.diagramUrl, success: { (diagramURL) in
                
                let data = (pdfURL: diagramURL, productURL: productURL)
                let wvnvc = PDFWebViewNavigationController.init(data: data, title: productName)
                wvnvc.modalPresentationStyle = .fullScreen
                
                self?.present(wvnvc, animated: true) {
                    self?.hud.hide(animated: true)
                }
            })
        }
        
        let productName = self.product.name
        if self.product.url == nil || self.product.url!.isEmpty {
            commonBlock(productName, nil)
        } else {
            self.sanitizeURLOrDisplayError(fromString: self.product.url) { (productURL) in
                commonBlock(productName, productURL)
            }
        }
    }
    
    
    // MARK: Helper methods
    
    private func sanitizeURLOrDisplayError(fromString string: String?, success: ((URL) -> Void)) {
        
        guard
            let strUrl = string,
            let url = URL(string: strUrl)
        else {
            self.hud.hide(animated: true)
            let msg = "An error occurred. Please try again or contact us through the Contact tab."
            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
            return
        }
        
        success(url)
    }
    
    
    private func applyButtonStyle(to button: UIButton) {
        
        button.titleLabel?.font = UIFont.appFontMedium(ofSize: 21.0)
        button.setTitleColor(UIColor.vtronixBlue, for: .normal)
        button.setTitleColor(UIColor.vtronixDarkBlue, for: .highlighted)
    }
    
}
