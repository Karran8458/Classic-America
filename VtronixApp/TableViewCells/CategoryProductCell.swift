//
//  CategoryProductCell.swift
//  VtronixApp
//
//  Created by samstag on 29.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import Kingfisher


class CategoryProductCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let placeholderImage = #imageLiteral(resourceName: "vtronix-text-logo-square")
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor.vtronixBlue.cgColor
        self.containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        self.titleLabel.font = UIFont.appFontMedium(ofSize: 18.0)
        self.titleLabel.textColor = .darkGray
        
        self.subtitleLabel.font = UIFont.appFontLight(ofSize: 14.0)
        self.subtitleLabel.textColor = .darkGray
        
        self.cellImageView.contentMode = .scaleToFill
        self.cellImageView.layer.cornerRadius = 8.0
        self.cellImageView.layer.borderWidth = 1.0
        self.cellImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        
        self.activityIndicator.hidesWhenStopped = true
    }
    
    
    override func prepareForReuse() {
        
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.cellImageView.image = nil
        self.activityIndicator.startAnimating()
    }
    
    
    func setContentWith(category: Category) {

        self.titleLabel.text = category.name
        let subtitle = category.subtitleForCategoryCell()
        self.subtitleLabel.text = subtitle
        self.subtitleLabel.isHidden = subtitle == nil
        
        self.activityIndicator.stopAnimating()
        self.cellImageView.image = self.placeholderImage
        if  let strImageURL = category.image,
            let imageURL = URL(string: strImageURL)
        {
            self.activityIndicator.startAnimating()
            self.cellImageView.kf.setImage(with: imageURL) { [weak self] (result) in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    func setContentWith(product: Product) {
        
        self.titleLabel.text = product.name
        let subtitle = product.description
        self.subtitleLabel.text = subtitle
        self.subtitleLabel.isHidden = subtitle == nil
        
        self.activityIndicator.stopAnimating()
        self.cellImageView.image = self.placeholderImage
        if  let strImageURL = product.image,
            let imageURL = URL(string: strImageURL)
        {
            self.activityIndicator.startAnimating()
            self.cellImageView.kf.setImage(with: imageURL) { [weak self] (result) in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
}
