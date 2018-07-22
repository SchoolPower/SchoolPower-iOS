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
class StudentInformation {
    
    enum Gender{
        case Male
        case Female
    }
    
    var GPA: Double?
    var id : Int = 0
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
    
    func getFullName() -> String {
        var middleNamePrefix = middleName
        if middleNamePrefix != "" {
            middleNamePrefix += " "
        }
        return middleNamePrefix + firstName + ", " + lastName
    }
}

