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

public extension URLSessionTaskEngine {
    // MARK: - Enums
    
    enum Error: LocalizedError, Equatable {
        case invalidSessionResponse
        case invalidStatusCode(statusCode: Int)
        case missingResponseItem
        
        // MARK: - <LocalizedError>
        
        public var errorDescription: String? {
            switch self {
            case .invalidSessionResponse:
                return "Invalid networking response"
            case .invalidStatusCode(let statusCode):
                return "Invalid status code: \(statusCode)"
            case .missingResponseItem:
                return "Missing response content"
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .invalidSessionResponse:
                return "Networking did not return a valid response"
            case .invalidStatusCode:
                return "The server responded with a status code outside the 200–299 success range"
            case .missingResponseItem:
                return "The response content is missing"
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .invalidSessionResponse:
                return "Verify your networking reuqest isn't malformed. The server is returning an invalid response."
            case .invalidStatusCode:
                return "Verify your networking request isn't malformed. The server may be rejecting your input."
            case .missingResponseItem:
                return "Verify that the server returns a valid response item"
            }
        }
    }
}
