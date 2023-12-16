//MIT License
//
//Copyright (c) 2020-2023 Ryan Baumbach <github@ryan.codes>
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
import Capsule

// MARK: - Trunk.OutputFormat

extension Trunk.OutputFormat: RawRepresentable {
    // MARK: - <RawRepresentable>
    
    public typealias RawValue = JSONCodableWrapper.OutputFormat
    
    public var rawValue: JSONCodableWrapper.OutputFormat {
        switch self {
        case .pretty:
            return .pretty
        default:
            return .default
        }
    }
    
    public init?(rawValue: JSONCodableWrapper.OutputFormat) {
        switch rawValue {
        case .pretty:
            self = .pretty
        default:
            self = .default
        }
    }
}

// MARK: - Trunk.DateFormat

extension Trunk.DateFormat: RawRepresentable {
    // MARK: - <RawRepresentable>
    
    public typealias RawValue = JSONCodableWrapper.DateFormat
    
    public var rawValue: JSONCodableWrapper.DateFormat {
        switch self {
        case .iso8601:
            return .iso8601
        default:
            return .default
        }
    }
    
    public init?(rawValue: JSONCodableWrapper.DateFormat) {
        switch rawValue {
        case .iso8601:
            self = .iso8601
        default:
            self = .default
        }
    }
}
