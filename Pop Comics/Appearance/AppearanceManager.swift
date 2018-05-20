//
//  AppearanceManager.swift
//  Pop Comics
//
//  Created by Justin Oakes on 19/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class AppearanceManager {
    
    static func applyDefaultTheme() {
        let fontAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: "BadaBoom BB", size: 18.0)!]
        UINavigationBar.appearance().titleTextAttributes = fontAttributes
    }
    
}
