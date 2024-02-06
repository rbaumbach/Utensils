//MIT License
//
//Copyright (c) 2020-2024 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

public typealias JSONExpressibleLiteral =
    ExpressibleByNilLiteral &  ExpressibleByStringLiteral & ExpressibleByIntegerLiteral &

    // Note: ExpressibleByFloatLiteral works for both Float and Double

    ExpressibleByFloatLiteral & ExpressibleByBooleanLiteral & 
    ExpressibleByDictionaryLiteral & ExpressibleByArrayLiteral

public struct JSONCodable: Codable, Equatable, JSONExpressibleLiteral {
    // MARK: - <AnyWrapper>
    
    public var anyValue: Any
    
    // MARK: - Init methods
    
    public init<T>(value: T?) {
        anyValue = value ?? ()
    }
    
    // MARK: - JSONExpressibleLiteralV2
    
    public init(nilLiteral: ()) {
        self.init(value: nilLiteral)
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value: value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value: value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value: value)
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        let anyHashableDictionary = Dictionary(uniqueKeysWithValues: elements)
        
        self.init(value: anyHashableDictionary)
    }
    
    public init(arrayLiteral elements: Any...) {
        self.init(value: elements)
    }
    
    // MARK: - <Codable>
    
    // MARK: - <Decodable>
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        guard !singleValueContainer.decodeNil() else {
            self.init(value: ())
            
            return
        }
        
        if let string = try? singleValueContainer.decode(String.self) {
            guard string.lowercased() != "null" else {
                self.init(value: ())
                
                return
            }
            
            guard string.lowercased() != "<null>" else {
                self.init(value: ())
                
                return
            }
            
            self.init(value: string)
        } else if let int = try? singleValueContainer.decode(Int.self) {
            self.init(value: int)
        } else if let double = try? singleValueContainer.decode(Double.self) {
            self.init(value: double)
        } else if let bool = try? singleValueContainer.decode(Bool.self) {
            self.init(value: bool)
        } else if let anyCodableDictionary = try? singleValueContainer.decode([String: JSONCodable].self) {
            let anyValueDictionary = anyCodableDictionary.mapValues { item in
                return item.anyValue
            }
            
            self.init(value: anyValueDictionary)
        } else if let anyDecodableArray = try? singleValueContainer.decode([JSONCodable].self) {
            let anyArray = anyDecodableArray.map { item in
                return item.anyValue
            }
            
            self.init(value: anyArray)
        } else {
            let errorContext = DecodingError.Context(codingPath: decoder.codingPath,
                                                     debugDescription: "Value cannot be decoded")
            
            throw DecodingError.typeMismatch(Any.self, errorContext)
        }
    }
    
    // MARK: - <Encodable>
    
    public func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        
        guard !(anyValue is ()) else {
            try singleValueContainer.encodeNil()
            
            return
        }
        
        if let encodableValue = anyValue as? Encodable {
            try encodableValue.encode(to: encoder)
        } else if let anyTypedDictionary = anyValue as? [String: Any] {
            let anyCodableDictionary = anyTypedDictionary.mapValues { anyValue in
                return JSONCodable(value: anyValue)
            }
            
            try singleValueContainer.encode(anyCodableDictionary)
        } else if let anyTypedArray = anyValue as? [Any] {
            let anyCodableArray = anyTypedArray.map { anyValue in
                return JSONCodable(value: anyValue)
            }
            
            try singleValueContainer.encode(anyCodableArray)
        } else {
            let errorContext = EncodingError.Context(codingPath: encoder.codingPath,
                                                     debugDescription: "Value cannot be encoded")
            
            throw EncodingError.invalidValue(anyValue, errorContext)
        }
    }
    
    // MARK: - <Equatable>
    
    public static func == (lhs: JSONCodable, rhs: JSONCodable) -> Bool {
        let lhsAnyValue = lhs.anyValue
        let rhsAnyValue = rhs.anyValue
        
        if lhsAnyValue is () && rhsAnyValue is () {
            return true
        }
        
        if let lhsString = lhsAnyValue as? String,
           let rhsString = rhsAnyValue as? String {
                return lhsString == rhsString
        } else if 
           let lhsInt = lhsAnyValue as? Int,
           let rhsInt = rhsAnyValue as? Int {
                return lhsInt == rhsInt
        } else if
            let lhsDouble = lhsAnyValue as? Double,
            let rhsDouble = lhsAnyValue as? Double {
                return lhsDouble == rhsDouble
        } else if
            let lhsBool = lhsAnyValue as? Bool,
            let rhsBool = rhsAnyValue as? Bool {
                return lhsBool == rhsBool
        } else if
            let lhsDictionary = lhsAnyValue as? [String: Any],
            let rhsDictionary = rhsAnyValue as? [String: Any] {
                return areDictionariesEqual(lhsDictionary, rhsDictionary)
        } else if
            let lhsArray = lhsAnyValue as? [Any],
            let rhsArray = rhsAnyValue as? [Any] {
                return areArraysEqual(lhsArray, rhsArray)
        } else {
            return false
        }
    }
    
    // MARK: - Private methods
    
    private static func areDictionariesEqual(_ dictionary1: [String: Any],
                                             _ dictionary2: [String: Any]) -> Bool {
        let nsDictionary1 = NSDictionary(dictionary: dictionary1)
        let nsDictionary2 = NSDictionary(dictionary: dictionary2)
        
        return nsDictionary1 == nsDictionary2
    }
    
    private static func areArraysEqual(_ array1: [Any],
                                       _ array2: [Any]) -> Bool {
        let nsArray1 = NSArray(array: array1)
        let nsArray2 = NSArray(array: array2)
        
        return nsArray1 == nsArray2
    }
}
