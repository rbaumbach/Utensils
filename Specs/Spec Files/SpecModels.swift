import Foundation
@testable import Utensils

// Validator spec examples

struct Dog: Validatable, Codable {
    var name = "Sparky"
    var breed = "Chihuahua"
    
    var isValid: Bool {
        return breed == "Chihuahua"
    }
}

class Dude: Validatable {
    var isValid: Bool {
        return true
    }
}
