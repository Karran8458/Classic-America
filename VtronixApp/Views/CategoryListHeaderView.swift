//
//  CategoryListHeaderView.swift
//  VtronixApp
//
//  Created by samstag on 6.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


class CategoryListHeaderView: UIView {
    
    typealias StaticSelf = CategoryListHeaderView
    
    static let measureLabel = UILabel.init()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    
    func setContent(richString: RichString, image: UIImage?) {
        
        self.imageView.image = image
        self.imageView.isHidden = image == nil
        
        self.textLabel.font = richString.font
        self.textLabel.textColor = richString.textColor
        self.textLabel.text = richString.text
    }
    
}


extension CategoryListHeaderView {
    
    static func estimatedHeight(forMaxWidth width: CGFloat,
                                richString: RichString,
                                isImageViewHidden: Bool = false)
        -> CGFloat
    {
        let imageViewAspectRatio: CGFloat = 7/2
        let verEdges: CGFloat = .zero
        let horEdges: CGFloat = 24.0
        let interElementSpacing: CGFloat = .zero
        
        let contentWidth = width - (2 * horEdges)
        
        var imageViewAreaHeight: CGFloat = .zero
        if !isImageViewHidden {
            imageViewAreaHeight = contentWidth * (1 / imageViewAspectRatio)
            imageViewAreaHeight += interElementSpacing
        }
        
        let label = StaticSelf.measureLabel
        label.numberOfLines = .zero
        label.font = richString.font
        label.text = richString.text
        let labelSize = label.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude))
        let textHeight = labelSize.height
        
        return .zero
            + verEdges
            + imageViewAreaHeight
            + textHeight
            + verEdges
    }
    
}
