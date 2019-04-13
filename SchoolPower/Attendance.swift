//
//  Copyright 2019 SchoolPower Studio
//

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
