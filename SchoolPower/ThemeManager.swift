//
//  Copyright 2018 SchoolPower Studio
//
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
    
    var noGradeImage: UIImage {
        switch self {
        case .light:
            return #imageLiteral(resourceName: "no_grades")
        case .dark:
            return #imageLiteral(resourceName: "no_grades_dark")
        }
    }
    
    var perfectAttendanceImage: UIImage {
        switch self {
        case .light:
            return #imageLiteral(resourceName: "perfect_attendance")
        case .dark:
            return #imageLiteral(resourceName: "perfect_attendance_dark")
        }
    }
}

class ThemeManager {
    
    static let userDefaults = UserDefaults.standard
    
    static func currentTheme() -> Theme {
        if let storedTheme = (userDefaults.value(forKey: DARK_THEME_KEY_NAME) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        userDefaults.setValue(theme.rawValue, forKey: DARK_THEME_KEY_NAME)
        userDefaults.synchronize()
        
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.2)
        UITableViewCell.appearance().selectedBackgroundView = bgColorView
        
        UISwitch.appearance().onTintColor = Utils.getAccent().withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = Utils.getAccent()
        UISwitch.appearance().tintColor = currentTheme().secondaryTextColor.withAlphaComponent(0.1)
    }
}
