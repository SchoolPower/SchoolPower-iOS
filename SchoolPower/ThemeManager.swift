//
//  Copyright 2018 SchoolPower Studio

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

//  Credit: Abhilash

//  https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92


import UIKit
import Foundation
import MaterialComponents.MaterialPalettes

enum Theme: Int {
    
    case light, dark
    
    var primaryColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.primary)
        case .dark:
            return UIColor(rgb: Colors.dark_color_primary)
        }
    }
    
    var primaryDarkColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.primary_dark)
        case .dark:
            return UIColor(rgb: Colors.dark_color_primary_dark)
        }
    }
    
    var windowBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.light_window_color)
        case .dark:
            return UIColor(rgb: Colors.dark_window_color)
        }
    }
    
    var primaryTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.light_text_color_primary)
        case .dark:
            return UIColor(rgb: Colors.dark_text_color_primary)
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.light_text_color_secondary)
        case .dark:
            return Colors.dark_text_color_secondary
        }
    }
    
    var cardBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(rgb: Colors.light_card_background)
        case .dark:
            return UIColor(rgb: Colors.dark_card_background)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
}

class ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: DARK_THEME_KEY_NAME) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        UserDefaults.standard.setValue(theme.rawValue, forKey: DARK_THEME_KEY_NAME)
        UserDefaults.standard.synchronize()
        
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.2)
        UITableViewCell.appearance().selectedBackgroundView = bgColorView
        
        UISwitch.appearance().onTintColor = theme.primaryColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.primaryColor
    }
}
