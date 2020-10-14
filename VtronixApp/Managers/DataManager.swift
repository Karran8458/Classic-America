//
//  DataManager.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import ObjectMapper


class DataManager {
    
    static let shared = DataManager.init()
    
    var rootCategory: Category?

    private let dataFileName = "data.json"

    
    init() {
        
        self.rootCategory = Mapper<Category>().map(JSONfile: self.dataFileName)
    }
    
    
    func allProducts() -> [Product] {
        
        guard let rootCat = self.rootCategory else { return [] }
        
        func productsOf(category: Category) -> [Product] {
            
            var categoryProducts: [Product] = []
            
            categoryProducts += category.products ?? []
            
            let subCategories = category.categories ?? []
            for subCategory in subCategories {
                categoryProducts += productsOf(category: subCategory)
            }
            
            return categoryProducts
        }
        
        return productsOf(category: rootCat)
    }
    
}
