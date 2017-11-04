//
//  Copyright 2017 SchoolPower Studio

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
import SwiftyJSON
/*
 Sample:
 {

 */
class Attendance {
    
    var code: String
    var description: String
    var date: String
    var period: String
    var subject: String
    
    init(json: JSON) {
        
        code = json["code"].stringValue
        description = json["description"].string ?? "--"
        date = json["date"].stringValue
        period = json["period"].string ?? "--"
        subject = json["name"].string ?? "--"
    }
}
