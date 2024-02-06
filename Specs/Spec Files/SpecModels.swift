import Foundation
@testable import Utensils

// Validator spec examples

struct Dog: Validatable, Codable, Equatable, Printable {
    var name = "Sparky"
    var breed = "Chihuahua"
    
    var isValid: Bool {
        return breed == "Chihuahua"
    }
    
    func print(_ printType: Utensils.PrintType) {
        Swift.print("Name: \(name)")
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
