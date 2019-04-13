
//
//  Copyright 2019 SchoolPower Studio
//

class SortableTerm {
    
    var raw: String = ""
    private var letter: String = ""
    private var index: Int = 0
    var value = 0
    
    init (raw: String) {
        self.raw = raw
        self.letter = String(raw.prefix(1))
        self.index = Int(raw.suffix(1)) ?? 0
        self.value = valueOfLetter(letter: letter) * index
    }
    
    private func valueOfLetter(letter: String) -> Int {
        // This is so that S1 > T4/Q4, Y1 > S2, X1 > Y1
        // Don't know what's X, assume it's greater than Y here :P
        switch letter {
        case "T": return 1
        case "Q": return 1
        case "S": return 5
        case "Y": return 11
        case "X": return 12
        default: return 0
        }
    }
}
