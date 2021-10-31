
//
//  Copyright 2019 SchoolPower Studio
//

class SortableTerm {
    
    var raw: String = ""
    var letter: String = ""
    var index: Int = 0
    var letterValue = 0
    
    init (raw: String) {
        self.raw = raw
        self.letter = String(raw.prefix(1))
        self.index = Int(raw.suffix(1)) ?? 0
        self.letterValue = valueOfLetter(letter: letter)
    }
    
    private func valueOfLetter(letter: String) -> Int {
        switch letter {
        case "F": return 1
        case "L": return 2
        case "E": return 3
        case "S": return 4
        default: return 5
        }
    }
}
