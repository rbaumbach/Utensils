import Foundation
@testable import Utensils

// Validator spec examples

struct Dog: Validatable, Codable, Equatable {
    var name = "Sparky"
    var breed = "Chihuahua"
    
    var isValid: Bool {
        return breed == "Chihuahua"
    }
}

class Dude: Validatable, Equatable {
    var isValid: Bool {
        return true
    }
    
    static func == (lhs: Dude, rhs: Dude) -> Bool {
        return lhs.isValid == rhs.isValid
    }
}
