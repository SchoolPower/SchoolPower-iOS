
//
//  Copyright 2019 SchoolPower Studio
//

class SortableTerm {
    
    var raw: String = ""
    var letter: String = ""
    var index: Int = 0
    var letterValue = 0
    
    init (raw: String, prioritizeSemester: Bool = false) {
        self.raw = raw
        self.letter = String(raw.prefix(1))
        self.index = Int(raw.suffix(1)) ?? 0
        self.letterValue = valueOfLetter(letter: letter, prioritizeSemester: prioritizeSemester)
    }
    
    private func valueOfLetter(letter: String, prioritizeSemester: Bool) -> Int {
        switch letter {
        case "F": return prioritizeSemester ? 2 : 1
        case "L": return prioritizeSemester ? 1 : 2
        case "E": return 3
        case "S": return 4
        default: return 0
        }
    }
}
