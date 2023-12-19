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

public extension PequenoNetworking {
    // MARK: - Enums
    
    enum Error: CaseIterable, LocalizedError, Equatable {
        case requestError(_ string: String)
        case dataTaskError(wrappedError: Swift.Error)
        case malformedResponseError
        case invalidStatusCodeError(statusCode: Int)
        case dataError
        case jsonDecodeError(wrappedError: Swift.Error)
        case jsonObjectDecodeError(wrappedError: Swift.Error)
        
        // MARK: - <CaseIterable>
        
        public static var allCases: [PequenoNetworking.Error] {
            return [.requestError(String.empty),
                    .dataTaskError(wrappedError: EmptyError.empty),
                    .malformedResponseError,
                    .invalidStatusCodeError(statusCode: 0),
                    .dataError,
                    .jsonDecodeError(wrappedError: EmptyError.empty),
                    .jsonObjectDecodeError(wrappedError: EmptyError.empty)]
        }
        
        // MARK: - <Error>
        
        public var localizedDescription: String {
            switch self {
            case .requestError(let string):
                return """
                Unable to build URLRequest:
                \(string)
                """
            case .dataTaskError(let error):
                return "Unable to complete data task successfully.  Wrapped Error: \(error.localizedDescription)"
            case .malformedResponseError:
                return "Unable to process response"
            case .invalidStatusCodeError(let statusCode):
                return "\(statusCode): Invalid status code"
            case .dataError:
                return "Data task does not contain data"
            case .jsonDecodeError(let error):
                return "Unable to decode json. Wrapped Error: \(error.localizedDescription)"
            case .jsonObjectDecodeError(let error):
                return "Unable to decode json object. Wrapped Error: \(error.localizedDescription)"
            }
        }
        
        // MARK: - <LocalizedError>
        
        public var errorDescription: String? {
            return localizedDescription
        }
        
        public var failureReason: String? {
            return localizedDescription
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .requestError:
                return "Verify that the request was built appropriately"
            case .dataTaskError:
                return "Verify that your data task was build appropriately"
            case .malformedResponseError:
                return "Verify that your response returned is not malformed"
            case .invalidStatusCodeError:
                return "200 - 299 are valid status codes"
            case .dataError:
                return "Verify server is returning valid data"
            case .jsonDecodeError:
                return "Verify that your Codable types match what is contained data from response"
            case .jsonObjectDecodeError:
                return "Verify that your json data is can be deserialized to Foundation objects"
            }
        }
        
        // MARK: - <Equatable>
        
        public static func == (lhs: Error, rhs: Error) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
    }
}