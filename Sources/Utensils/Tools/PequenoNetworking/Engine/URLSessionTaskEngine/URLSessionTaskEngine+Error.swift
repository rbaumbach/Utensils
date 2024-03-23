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
    
    enum Error<T>: CaseIterable, LocalizedError, Equatable {
        case invalidSessionResponse
        case invalidStatusCode(statusCode: Int, responseData: Data?)
        case invalidSessionItem(type: T.Type)
        
        // MARK: - <CaseIterable>
        
        public static var allCases: [Error] {
            return [.invalidSessionResponse,
                    .invalidStatusCode(statusCode: 0, responseData: nil),
                    .invalidSessionItem(type: T.self)]
        }
        
        // MARK: - <Error>
        
        public var localizedDescription: String {
            switch self {
            case .invalidSessionResponse:
                return "Invalid URLSession task response"
            case .invalidStatusCode(let statusCode, let responseData):
                return "Invalid status code: \(statusCode)"
            case .invalidSessionItem(let type):
                return "Invalid URLSession task item of type: \(type.self)"
            }
        }
        
        // MARK: - <LocalizedError>
        
        public var errorDescription: String? {
            switch self {
            case .invalidStatusCode:
                return "200 - 299 are valid status codes"
            default:
                return localizedDescription
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .invalidSessionResponse:
                return "HTTPURLResponse returned by URLSession task is nil"
            case .invalidStatusCode:
                return localizedDescription
            case .invalidSessionItem(let type):
                return "Item returned by URLSession task of type \(type.self) is nil"
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .invalidStatusCode:
                return "Verify your URLSession task is built appropriately as required by your API"
            default:
                return localizedDescription
            }
        }
        
        // MARK: - Equatable
        
        public static func == (lhs: URLSessionTaskEngine.Error<T>, rhs: URLSessionTaskEngine.Error<T>) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
    }
}
