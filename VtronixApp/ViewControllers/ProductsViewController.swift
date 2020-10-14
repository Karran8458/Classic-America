//
//  ProductsViewController.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


// MARK: - ProductsViewController

class ProductsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var category: Category?
    var products: [Product] { return self.category?.products ?? [] }
    
    private let categoryProductCellId = "CategoryProductCellIdentifier"
    
    
    init(category: Category?) {
        
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
        
        self.sharedInit()
    }
    

    required init?(coder: NSCoder) {

        fatalError("This class does not support `init?(coder:)`. Use `init(category:)` instead.")
    }
    
    
    private func sharedInit() {
        
        self.title = self.category?.name
        self.tabBarItem.image = #imageLiteral(resourceName: "tab-products")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.applySharedNavigationBarStyle()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: "CategoryProductCell", bundle: nil), forCellReuseIdentifier: self.categoryProductCellId)
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset.top = 16.0
        self.tableView.contentInset.bottom = 16.0
        
        self.tableView.estimatedRowHeight = 144.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.category == nil {
            let msg = "An error occurred. Please try again or contact us through the Contact tab."
            UIAlertController.presentPlainAlertIn(self, title: "Info", message: msg)
        }
    }
    
}


// MARK: - UITableViewDataSource

extension ProductsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.categoryProductCellId,
                                                       for: indexPath) as? CategoryProductCell
        else { return UITableViewCell.init() }
        
        let product = self.products[indexPath.row]
        cell.setContentWith(product: product)
        cell.selectionStyle = .none
        
        return cell
    }
    
}


// MARK: UITableViewDelegate

extension ProductsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = self.products[indexPath.row]
        let pvc = ProductViewController.init(product: product)
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Products"
    }
    
}
