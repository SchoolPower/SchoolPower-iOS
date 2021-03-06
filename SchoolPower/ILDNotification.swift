//
//  Copyright 2019 SchoolPower Studio
//

import SwiftyJSON
/*
 Sample:
 {
 "ildNotification": {
     "show": "true",
     "uuid": "9d8e55d4-f75b-4cc4-86d4-d66bfd8d4d11",
     "image": "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg",
     "titles": [
         "Title",
         "标题",
         "標題",
     ],
     "messages": [
         "Message",
         "消息",
         "消息",
     ],
     "primaryTexts": [
         "OK",
         "好的",
         "好的",
     ],
     "secondaryTexts": [
         "",
         "",
         "",
     ],
     "dismissTexts": [
         "",
         "",
         "",
     ],
     "hideDismiss": "true",
     "hideSecondary": "true",
     "onlyOnce": "true",
     "primaryOnClick": "-1"
     }
 }

 */
class ILDNotification {
    
    var show: Bool = false
    var uuid: String = ""
    var headerImageURL: String = ""
    var titles: Array<String> = ["", "", "", ""]
    var messages: Array<String> = ["", "", "", ""]
    var primaryTexts: Array<String> = ["", "", "", ""]
    var secondaryTexts: Array<String> = ["", "", "", ""]
    var dismissTexts: Array<String> = ["", "", "", ""]
    var hideDismiss: Bool = true
    var hideSecondary: Bool = true
    var onlyOnce: Bool = true
    
    // Experimental
    var primaryOnClickListenerIndex: Int = -1
    
    init() {
        
    }
    
    init(jsonStr: String) {
        let json = JSON.init(rawValue: jsonStr) ?? "{}"
        let notification = json["ildNotification"]
        show = notification["show"].boolValue
        uuid = notification["uuid"].stringValue
        headerImageURL = notification["image"].stringValue
        titles = notification["titles"].arrayValue.stringArray
        messages = notification["messages"].arrayValue.stringArray
        primaryTexts = notification["primaryTexts"].arrayValue.stringArray
        secondaryTexts = notification["secondaryTexts"].arrayValue.stringArray
        dismissTexts = notification["dismissTexts"].arrayValue.stringArray
        hideDismiss = notification["hideDismiss"].boolValue
        hideSecondary = notification["hideSecondary"].boolValue
        onlyOnce = notification["onlyOnce"].boolValue
        primaryOnClickListenerIndex = notification["primaryOnClickListenerIndex"].intValue
    }
    
    init(json: JSON) {
        let notification = json["ildNotification"]
        show = notification["show"].boolValue
        uuid = notification["uuid"].stringValue
        headerImageURL = notification["image"].stringValue
        titles = notification["titles"].arrayValue.stringArray
        messages = notification["messages"].arrayValue.stringArray
        primaryTexts = notification["primaryTexts"].arrayValue.stringArray
        secondaryTexts = notification["secondaryTexts"].arrayValue.stringArray
        dismissTexts = notification["dismissTexts"].arrayValue.stringArray
        hideDismiss = notification["hideDismiss"].boolValue
        hideSecondary = notification["hideSecondary"].boolValue
        onlyOnce = notification["onlyOnce"].boolValue
        primaryOnClickListenerIndex = notification["primaryOnClickListenerIndex"].intValue
    }
}

extension Array where Element == JSON {
    public var stringArray: Array<String> {
        var array = Array<String>()
        for item in self {
            array.append(item.stringValue)
        }
        return array
    }
}
