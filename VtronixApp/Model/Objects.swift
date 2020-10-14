//
//  Objects.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper


class Category: Mappable {
    
    var name: String?
    var image: String?
    var description: String?
    var url: String?
    var isRoot: Bool = false
    var products: [Product]?
    var categories: [Category]?
    

    required init?(map: Map) { }
    

    func mapping(map: Map) {

        self.name <- map["name"]
        self.image <- map["image"]
        self.description <- map["description"]
        self.url <- map["url"]
        self.isRoot <- map["is_root"]
        self.products <- map["products"]
        self.categories <- map["categories"]
    }
    
    
    func subtitleForCategoryCell() -> String? {
        
        var subtitle: String?
        if  let productsCount = self.products?.count,
            productsCount > 0
        {
            subtitle = "\(productsCount) Products"
        }
        if  let categoriesCount = self.categories?.count,
            categoriesCount > 0
        {
            subtitle = "\(categoriesCount) Categories"
        }
        return subtitle
    }
    
}


class Product: Mappable {
    
    var name: String?
    var image: String?
    var description: String?
    var diagramUrl: String?
    var instUrl: String?
    var specsUrl: String?
    var url: String?
    

    required init?(map: Map) { }
    

    func mapping(map: Map) {

        self.name <- map["name"]
        self.image <- map["image"]
        self.description <- map["description"]
        self.diagramUrl <- map["diagram_url"]
        self.instUrl <- map["inst_url"]
        self.specsUrl <- map["specs_url"]
        self.url <- map["url"]
    }
    
}


struct RichString {

    var text: String
    var font: UIFont
    var textColor: UIColor


    init(text: String, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular, textColor: UIColor) {
        
        self.text = text
        self.textColor = textColor
        
        switch fontWeight {
        case .bold:
            self.font = UIFont.appFontBold(ofSize: fontSize)
        case.light:
            self.font = UIFont.appFontLight(ofSize: fontSize)
        case .medium:
            self.font = UIFont.appFontMedium(ofSize: fontSize)
        case .semibold:
            self.font = UIFont.appFontSemiBold(ofSize: fontSize)
        default:
            self.font = UIFont.appFontRegular(ofSize: fontSize)
        }
    }

}
