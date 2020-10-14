//
//  CategoryListFooterView.swift
//  VtronixApp
//
//  Created by samstag on 6.05.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


class CategoryListFooterView: UICollectionReusableView {
    
    typealias StaticSelf = CategoryListHeaderView
    
    static let measureLabel = UILabel.init()
    
    @IBOutlet var textLabel: UILabel!
    
    
    func setContent(richString: RichString) {
        
        self.textLabel.font = richString.font
        self.textLabel.textColor = richString.textColor
        self.textLabel.text = richString.text
    }

}


extension CategoryListFooterView {
    
    static func estimatedHeight(forMaxWidth width: CGFloat,
                                richString: RichString)
        -> CGFloat
    {
        let verEdgesTop: CGFloat = .zero
        let verEdgesBottom: CGFloat = 24.0
        let horEdges: CGFloat = 24.0
        
        let contentWidth = width - (2 * horEdges)
        
        let label = StaticSelf.measureLabel
        label.numberOfLines = .zero
        label.font = richString.font
        label.text = richString.text
        let labelSize = label.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude))
        let textHeight = labelSize.height
        
        return .zero
            + verEdgesTop
            + textHeight
            + verEdgesBottom
    }
    
}
