//
//  StudentInformation.swift
//  SchoolPower
//
//  Created by Null on 2017-09-18.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import Foundation
import SwiftyJSON

class StudentInformation {
    /*
     Sample:
     {
     "currentGPA": null,
     "currentMealBalance": "0.0",
     "currentTerm": null,
     "dcid": "10000",
     "dob": "2001-01-01T16:00:00.000Z",
     "ethnicity": null,
     "firstName": "John",
     "gender": "M",
     "gradeLevel": "10",
     "id": "10000",
     "lastName": "Doe",
     "middleName": "English Name",
     "photoDate": "2016-01-01T16:10:05.699Z",
     "startingMealBalance": "0.0"
     }
     */
    
    enum Gender{
        case Male
        case Female
    }
    
    var GPA: Double?
    var id : Int=0
    var gender : Gender
    var dob : String
    var firstName : String
    var middleName : String
    var lastName : String
    var photoDate : String

    init(json:JSON) {
        GPA        = json["currentGPA"].double
        //id         = Int(json["id"].stringValue)!
        gender     = (json["gender"].stringValue == "M") ? Gender.Male : Gender.Female
        dob        = json["dob"].stringValue
        firstName  = json["firstName"].stringValue
        middleName = json["middleName"].stringValue
        lastName   = json["lastName"].stringValue
        photoDate  = json["photoDate"].stringValue
    }

    
    func getFullName() -> String { return middleName+" "+firstName+", "+lastName }

}
