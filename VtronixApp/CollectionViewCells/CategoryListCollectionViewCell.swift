//
//  CategoryItem.swift
//  VtronixApp
//
//  Created by samstag on 5.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


// MARK: - CategoryListCollectionViewCell

class CategoryListCollectionViewCell: UICollectionViewCell {
    
    typealias StaticSelf = CategoryListCollectionViewCell
    
    static private let titleFont = UIFont.appFontSemiBold(ofSize: 18.0)
    static private let subtitleFont = UIFont.appFontRegular(ofSize: 16.0)
    static private let measureLabel = UILabel.init()
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    private let placeholderImage = #imageLiteral(resourceName: "vtronix-text-logo-square")
    private let titleColor = UIColor.gray
    private let subtitleColor = UIColor.lightGray
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.containerView.layer.shadowOpacity = 0.2
        self.containerView.layer.shadowRadius = 4.0
        self.containerView.layer.shouldRasterize = true
        self.containerView.layer.rasterizationScale = UIScreen.main.scale
        
        self.imageView.layer.cornerRadius = 8.0
        self.imageView.clipsToBounds = true
        
        self.titleLabel.font = StaticSelf.titleFont
        self.titleLabel.textColor = self.titleColor
        
        self.subtitleLabel.font = StaticSelf.subtitleFont
        self.subtitleLabel.textColor = self.subtitleColor
    }

    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.activityIndicator.startAnimating()
        self.setHighlightedState(false)
    }
    
    
    func setContent(imageURLOrName: String = "", title: String, subtitle: String) {
        
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        
        self.activityIndicator.stopAnimating()
        self.imageView.image = self.placeholderImage
        if !imageURLOrName.isEmpty {
            if  let imageURL = URL(string: imageURLOrName),
                UIApplication.shared.canOpenURL(imageURL)
            {
                self.activityIndicator.startAnimating()
                self.imageView.kf.setImage(with: imageURL) { [weak self] (result) in
                    self?.activityIndicator.stopAnimating()
                }
            }
            else if let image = UIImage(named: imageURLOrName)
            {
                self.imageView.image = image
            }
        }
    }
    
    
    func setHighlightedState(_ isHighlighted: Bool) {
        
        if isHighlighted {
            self.containerView.backgroundColor = UIColor.vtronixBlue.withAlphaComponent(0.8)
            self.titleLabel.textColor = .white
            self.subtitleLabel.textColor = .white
        } else {
            self.containerView.backgroundColor = .white
            self.titleLabel.textColor = self.titleColor
            self.subtitleLabel.textColor = self.subtitleColor
        }
    }
    
}


// MARK: - Static method for height calculation

extension CategoryListCollectionViewCell {
    
    static func height(forWidth width: CGFloat, title: String, subtitle: String) -> CGFloat {
        
        let horEdges: CGFloat = 34.0
        let verEdges: CGFloat = 30.0
        let interElSpacing: CGFloat = 20.0
        let labelsSpacing: CGFloat = 8.0
        
        let maxWidth = width - (2 * horEdges)
        let imageViewHeight = maxWidth

        let label = StaticSelf.measureLabel
        label.numberOfLines = 0
        
        label.font = StaticSelf.titleFont
        label.text = title
        let titleSize = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let titleHeight = titleSize.height
        
        label.font = StaticSelf.subtitleFont
        label.text = subtitle
        let subtitleSize = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let subtitleHeight = subtitleSize.height
        
        return .zero
            + verEdges
            + imageViewHeight
            + interElSpacing
            + titleHeight + labelsSpacing + subtitleHeight
            + verEdges
    }
    
}
