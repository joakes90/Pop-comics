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
        let headlineFontAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: "BadaBoom BB", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)]
        UINavigationBar.appearance().titleTextAttributes = headlineFontAttributes

    }
    
}
