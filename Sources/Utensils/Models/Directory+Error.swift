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

public extension Directory {
    // MARK: - Enums
    
    enum Error: CaseIterable, LocalizedError, Equatable {
        case unableToCreateDirectory(url: URL, wrappedError: Swift.Error)
        
        // MARK: - <CaseIterable>
        
        public static var allCases: [Directory.Error] {
            return [.unableToCreateDirectory(url: URL.empty, wrappedError: EmptyError.empty)]
        }
        
        // MARK: - <Error>
        
        public var localizedDescription: String {
            switch self {
            case .unableToCreateDirectory(let url, let wrappedError):
                return """
                Unable to create directory:
                \(url)
                wrappedError:
                \(wrappedError)
                """
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
            case .unableToCreateDirectory:
                return "Verify path is valid, current file doesn't have same directory name and/or have enough disk space"
            }
        }
        
        // MARK: - <Equatable>
        
        public static func == (lhs: Error, rhs: Error) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
    }
}
