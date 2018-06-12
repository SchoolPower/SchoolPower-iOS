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
import SwiftyJSON
/*
 Sample:
 {
     "code": "E",
     "description": "Excused Absent",
     "date": "2017-10-16T16:00:00.000Z",
     "period": "3(B,D)",
     "name": "Chinese Social Studies 11"
 }
 */
class Attendance {
    
    var code: String
    var description: String
    var date: String
    var period: String
    var subject: String
    
    init(json: JSON) {
        
        let df1 = DateFormatter()
        let df2 = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        df2.dateFormat = "yyyy/MM/dd"
        
        code = json["code"].stringValue
        description = json["description"].stringValue
        date = df2.string(from: df1.date(from: json["date"].stringValue)!)
        period = json["period"].stringValue
        subject = json["name"].stringValue
    }
    
    var isNew = false
}
