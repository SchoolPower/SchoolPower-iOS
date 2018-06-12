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


import Foundation
import UIKit
import MaterialComponents.MaterialPalettes

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class Colors{
    
    static let A_score_green = 0x00796B
    static let A_score_green_dark = 0x006156
    static let B_score_green = 0x388E3C
    static let B_score_green_dark = 0x2D7230
    static let Cp_score_yellow_lighter = 0xffd180
    static let Cp_score_yellow_light = 0xffd740
    static let Cp_score_yellow = 0xffb300
    static let Cp_score_yellow_dark = 0xcc8f00
    static let Cp_score_yellow_darker = 0x827717
    static let C_score_orange = 0xFF5722
    static let C_score_orange_dark = 0xcc461b
    static let Cm_score_red = 0xD32F2F
    static let Cm_score_red_dark = 0xa92626
    static let primary_light = 0xEEEEEE
    static let primary = 0x09314b
    static let primary_dark = 0x07263b
    static let primary_darker = 0x061d2f
    static let accent = 0x00c4cf
    static let gray = 0x727272
    static let white = 0xFFFFFF
    static let white_0_5 = 0x32FFFFFF
    static let white_0_10 = 0x64FFFFFF
    static let white_0_20 = 0xC8FFFFFF as UInt32
    static let foreground_material_dark = 0xeeeeee
    static let text_primary_black = 0x383838
    static let text_secondary_black = 0x787878
    static let text_tertiary_black = 0x909090
    static let cardview_dark_background = 0x424242
    static let nothing_light = 0xFAFAFA
    
    static let light_window_color = 0xF4F4F4
    static let light_text_color_primary = 0x212121
    static let light_text_color_secondary = 0x757575
    static let light_card_background = 0xFFFFFF
    
    static let dark_color_primary = 0x2D3035
    static let dark_color_primary_dark = 0x26282C
    static let dark_window_color = 0x22252A
    static let dark_text_color_primary = 0xEEEEEE
    static let dark_text_color_secondary = MDCPalette.grey.tint500
    static let dark_card_background = 0x2D3035
    
    static let chartColorList = [
        
        UIColor(rgb: 0xff1744),
        UIColor(rgb: 0xf50057),
        UIColor(rgb: 0xd500f9),
        UIColor(rgb: 0x651fff),
        UIColor(rgb: 0x3d5afe),
        UIColor(rgb: 0x00b0ff),
        UIColor(rgb: 0x00e5ff),
        UIColor(rgb: 0x00e676),
        UIColor(rgb: 0x76ff03),
        UIColor(rgb: 0xc6ff00),
        UIColor(rgb: 0xffea00),
        UIColor(rgb: 0xffc400),
        UIColor(rgb: 0xff3d00),
        UIColor(rgb: 0xff9100),
        UIColor(rgb: 0x3e2723)
        
    ]
}
