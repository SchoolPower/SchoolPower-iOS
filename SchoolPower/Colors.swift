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
    
    static let alipay_blue = 0x1296db
    static let wechat_green = 0x22AC38
    static let paypal_blue = 0x253B80
    static let bitcoin_orange = 0xF7931A
    static let ethereum_black = 0x282828
    
    static let chartColorList = [
        UIColor(rgb: 0xff1744),
        UIColor(rgb: 0x534550),
        UIColor(rgb: 0xc0de32),
        UIColor(rgb: 0x904cdb),
        UIColor(rgb: 0x76ca52),
        UIColor(rgb: 0xc953b8),
        UIColor(rgb: 0x67bc84),
        UIColor(rgb: 0x5d4da6),
        UIColor(rgb: 0xc3a83f),
        UIColor(rgb: 0x858fbf),
        UIColor(rgb: 0xd7552d),
        UIColor(rgb: 0x65bebe),
        UIColor(rgb: 0xb8517b),
        UIColor(rgb: 0x919652),
        UIColor(rgb: 0xad5844),
        UIColor(rgb: 0xa49a85)
        
    ]
    
    static let materialChartColorList = [
        MDCPalette.red.tint500,
        MDCPalette.purple.tint500,
        MDCPalette.purple.accent400!,
        MDCPalette.deepPurple.tint500,
        MDCPalette.indigo.tint500,
        MDCPalette.blue.tint500,
        MDCPalette.cyan.tint500,
        MDCPalette.teal.tint500,
        MDCPalette.teal.accent700!,
        MDCPalette.lightGreen.tint500,
        MDCPalette.yellow.tint500,
        MDCPalette.yellow.accent100!,
        MDCPalette.orange.tint500,
        MDCPalette.deepOrange.tint500,
        MDCPalette.brown.tint500,
        MDCPalette.grey.tint500,
        MDCPalette.blueGrey.tint500
    ]
    
    static let accentColors = [
        MDCPalette.pink.tint200,
        MDCPalette.pink.tint300,
        MDCPalette.pink.tint400,
        MDCPalette.pink.tint500,
        MDCPalette.pink.tint600,
        MDCPalette.pink.tint700,
        MDCPalette.red.tint200,
        MDCPalette.red.tint300,
        MDCPalette.red.tint400,
        MDCPalette.red.tint500,
        MDCPalette.red.tint600,
        MDCPalette.red.tint700,
        MDCPalette.purple.tint200,
        MDCPalette.purple.tint300,
        MDCPalette.purple.tint400,
        MDCPalette.purple.tint500,
        MDCPalette.purple.tint600,
        MDCPalette.purple.tint700,
        MDCPalette.blue.tint200,
        MDCPalette.blue.tint300,
        MDCPalette.blue.tint400,
        MDCPalette.blue.tint500,
        MDCPalette.blue.tint600,
        MDCPalette.blue.tint700,
        MDCPalette.cyan.tint200,
        MDCPalette.cyan.tint300,
        MDCPalette.cyan.tint400,
        MDCPalette.cyan.tint500,
        MDCPalette.cyan.tint600,
        MDCPalette.cyan.tint700,
        MDCPalette.teal.tint200,
        MDCPalette.teal.tint300,
        MDCPalette.teal.tint400,
        MDCPalette.teal.tint500,
        MDCPalette.teal.tint600,
        MDCPalette.teal.tint700,
        MDCPalette.green.tint200,
        MDCPalette.green.tint300,
        MDCPalette.green.tint400,
        MDCPalette.green.tint500,
        MDCPalette.green.tint600,
        MDCPalette.green.tint700,
        MDCPalette.lightGreen.tint200,
        MDCPalette.lightGreen.tint300,
        MDCPalette.lightGreen.tint400,
        MDCPalette.lightGreen.tint500,
        MDCPalette.lightGreen.tint600,
        MDCPalette.lightGreen.tint700,
        MDCPalette.yellow.tint200,
        MDCPalette.yellow.tint300,
        MDCPalette.yellow.tint400,
        MDCPalette.yellow.tint500,
        MDCPalette.yellow.tint600,
        MDCPalette.yellow.tint700,
        MDCPalette.orange.tint200,
        MDCPalette.orange.tint300,
        MDCPalette.orange.tint400,
        MDCPalette.orange.tint500,
        MDCPalette.orange.tint600,
        MDCPalette.orange.tint700,
        MDCPalette.deepOrange.tint200,
        MDCPalette.deepOrange.tint300,
        MDCPalette.deepOrange.tint400,
        MDCPalette.deepOrange.tint500,
        MDCPalette.deepOrange.tint600,
        MDCPalette.deepOrange.tint700,
        MDCPalette.brown.tint200,
        MDCPalette.brown.tint300,
        MDCPalette.brown.tint400,
        MDCPalette.brown.tint500,
        MDCPalette.brown.tint600,
        MDCPalette.brown.tint700,
        MDCPalette.grey.tint200,
        MDCPalette.grey.tint300,
        MDCPalette.grey.tint400,
        MDCPalette.grey.tint500,
        MDCPalette.grey.tint600,
        MDCPalette.grey.tint700,
        MDCPalette.blueGrey.tint200,
        MDCPalette.blueGrey.tint300,
        MDCPalette.blueGrey.tint400,
        MDCPalette.blueGrey.tint500,
        MDCPalette.blueGrey.tint600,
        MDCPalette.blueGrey.tint700,
    ]
    
    static func getCyanPosInAccent() -> Int {
        return accentColors.index(of: MDCPalette.cyan.tint500) ?? 0
    }
    
//    static let accentColors = [
//        UIColor(rgb: 0xFF1744),
//        UIColor(rgb: 0xF50057),
//        UIColor(rgb: 0xD500F9),
//        UIColor(rgb: 0x651FFF),
//        UIColor(rgb: 0x3D5AFE),
//        UIColor(rgb: 0x2979FF),
//        UIColor(rgb: 0x00B0FF),
//        UIColor(rgb: 0x00E5FF),
//        UIColor(rgb: 0x1DE9B6),
//        UIColor(rgb: 0x00E676),
//        UIColor(rgb: 0x76FF03),
//        UIColor(rgb: 0xC6FF00),
//        UIColor(rgb: 0xFFEA00),
//        UIColor(rgb: 0xFFC400),
//        UIColor(rgb: 0xFF9100),
//        UIColor(rgb: 0xFF3D00)
//    ]
}
