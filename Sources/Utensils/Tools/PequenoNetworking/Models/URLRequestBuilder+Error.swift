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
import Capsule

public extension URLRequestBuilder {
    // MARK: - Enums
    
    enum Error: CaseIterable, LocalizedError, Equatable {
        case invalidURL(urlString: String)
        case invalidBody(body: [String: Any], 
                         wrappedError: Swift.Error)
        
        // MARK: - <CaseIterable>
        
        public static var allCases: [Error] {
            let emptyDictionary: [String: Any] = [:]
            
            return [.invalidURL(urlString: String.empty),
                    .invalidBody(body: emptyDictionary, 
                                 wrappedError: EmptyError.empty)]
        }
        
        // MARK: - <Error>
        
        public var localizedDescription: String {
            switch self {
            case .invalidURL(let urlString):
                return "Invalid URL: \(urlString)"
            case .invalidBody(let body, let wrappedError):
                return "Invalid body: \(body.description), wrappedError: \(wrappedError)"
            }
        }
        
        // MARK: - <LocalizedError>
        
        public var errorDescription: String? {
            return localizedDescription
        }
        
        public var failureReason: String? {
            switch self {
            case .invalidBody:
                return "Body cannot be serialized"
            default:
                return localizedDescription
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .invalidURL:
                return "Verify that the full URL from the URLRequestInfo object is valid"
            case .invalidBody:
                return "Verify that the body from the URLRequestInfo object is valid"
            }
        }
        
        // MARK: - Equatable
        
        public static func == (lhs: Error, rhs: Error) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
    }
}
