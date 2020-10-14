//
//  Extensions.swift
//  VtronixApp
//
//  Created by samstag on 29.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


extension UIColor {
    static let vtronixBlue = UIColor.init(named: "vtronix-blue") ?? .blue
    static let vtronixDarkBlue = UIColor.init(named: "vtronix-dark-blue") ?? .blue
}


extension UIFont {

    static func appFontBold(ofSize size: CGFloat) -> UIFont {

        return UIFont.init(name: "Barlow-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }


    static func appFontLight(ofSize size: CGFloat) -> UIFont {

        return UIFont.init(name: "Barlow-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }


    static func appFontMedium(ofSize size: CGFloat) -> UIFont {

        return UIFont.init(name: "Barlow-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }


    static func appFontRegular(ofSize size: CGFloat) -> UIFont {

        return UIFont.init(name: "Barlow-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }


    static func appFontSemiBold(ofSize size: CGFloat) -> UIFont {

        return UIFont.init(name: "Barlow-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }

}


extension UINavigationController {
    
    func applySharedNavigationBarStyle() {
        
        self.navigationBar.titleTextAttributes = [.font: UIFont.appFontMedium(ofSize: 18.0)]
    }
    
}


extension UIAlertController {
    
    static func presentPlainAlertIn(_ vc: UIViewController,
                                    title: String? = nil,
                                    message: String,
                                    closeHandler: ((UIAlertAction) -> Void)? = nil)
    {
        let avc = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Close", style: .cancel, handler: closeHandler))
        vc.present(avc, animated: true, completion: nil)
    }
    
}
