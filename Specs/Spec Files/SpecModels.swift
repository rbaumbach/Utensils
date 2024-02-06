import Foundation
@testable import Utensils

// Validator spec examples

struct Dog: Validatable, Codable, Equatable, Printable {
    var name = "Sparky"
    var breed = "Chihuahua"
    
    var isValid: Bool {
        return breed == "Chihuahua"
    }
    
    func print(_ printType: PrintType) -> String {
        switch printType {
        case .lite:
            return "Name: \(name)"
        case .verbose:
            return "Name: \(name), Breed: \(breed)"
        case .raw:
            return "\(self)"
        }
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
