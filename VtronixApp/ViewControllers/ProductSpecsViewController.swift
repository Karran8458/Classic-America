//
//  ProductSpecsViewController.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import MBProgressHUD


// MARK: - ProductSpecsViewController

class ProductSpecsViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    lazy var hud: MBProgressHUD = {
        let mbph = MBProgressHUD(view: self.view)
        self.view.addSubview(mbph)
        return mbph
    }()
    
    private let products = DataManager.shared.allProducts()
    private var filteredProducts: [Product] = []
    
    private let categoryProductCellId = "CategoryProductCellIdentifier"
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.sharedInit()
    }
    

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        
        self.sharedInit()
    }
    
    
    private func sharedInit() {
        
        self.title = "Product Specs"
        self.tabBarItem.image = #imageLiteral(resourceName: "tab-product-specs")
        self.filterProducts()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.applySharedNavigationBarStyle()
        
        self.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: "CategoryProductCell", bundle: nil), forCellReuseIdentifier: self.categoryProductCellId)
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset.top = 16.0
        self.tableView.contentInset.bottom = 16.0
        
        self.tableView.estimatedRowHeight = 144.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func filterProducts(usingText text: String = "") {
        
        if text == "" {
            self.filteredProducts = self.products
        } else {
            self.filteredProducts = self.products.filter({ ($0.name?.lowercased() ?? "").contains(text.lowercased()) })
        }
    }
    
}


// MARK: - UITableViewDataSource

extension ProductSpecsViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.categoryProductCellId,
                                                       for: indexPath) as? CategoryProductCell
        else { return UITableViewCell.init() }
        
        let product = self.filteredProducts[indexPath.row]
        cell.setContentWith(product: product)
        cell.selectionStyle = .none
        
        return cell
    }

}


// MARK: - UITableViewDelegate

extension ProductSpecsViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = self.filteredProducts[indexPath.row]
        if  let strPDFUrl = product.specsUrl,
            let pdfURL = URL(string: strPDFUrl)
        {
            let strProductUrl = product.url ?? ""
            let productURL = URL(string: strProductUrl)
            let data = (pdfURL: pdfURL, productURL: productURL)
            let wvnvc = PDFWebViewNavigationController.init(data: data, title: product.name)
            wvnvc.modalPresentationStyle = .fullScreen
            
            self.hud.show(animated: true)
            self.present(wvnvc, animated: true) { [weak self] in
                self?.hud.hide(animated: true)
            }
        }
    }
}


// MARK: - UISearchBarDelegate

extension ProductSpecsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterProducts(usingText: searchText)
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
}
