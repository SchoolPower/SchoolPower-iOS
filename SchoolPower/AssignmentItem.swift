//
//  AssignmentItem.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-22.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import Foundation

class AssignmentItem {
    
    var isNew = false
    var assignmentTitle: String
    var assignmentDate: String
    var assignmentPercentage: String
    var assignmentDividedScore: String
    var assignmentGrade: String
    var assignmentCategory: String
    var assignmentTerm: String
    
    init(_assignmentTitle: String, _assignmentDate: String, _assignmentPercentage: String,
          _assignmentDividedScore: String, _assignmentGrade: String, _assignmentCategory: String,
          _assignmentTerm: String) {
        
        assignmentTitle = _assignmentTitle
        assignmentDate = _assignmentDate
        assignmentPercentage = _assignmentPercentage
        assignmentDividedScore = _assignmentDividedScore
        assignmentGrade = _assignmentGrade
        assignmentCategory = _assignmentCategory
        assignmentTerm = _assignmentTerm
    }
}
