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

public extension FileLoader {
    enum Error: CaseIterable, LocalizedError, Equatable {
        case unableToFindFile(fileName: String)
        case unableToLoadJSONData(wrappedError: Swift.Error)
        case unableToDecodeJSONData(wrappedError: Swift.Error)
        
        // MARK: - <CaseIterable>
        
        public static var allCases: [Error] {
            return [.unableToFindFile(fileName: String.empty),
                    .unableToLoadJSONData(wrappedError: EmptyError.empty),
                    .unableToDecodeJSONData(wrappedError: EmptyError.empty)]
        }
        
        // MARK: - <Error>
        
        public var localizedDescription: String {
            switch self {
            case .unableToFindFile(let fileName):
                return "Unable to find file: \(fileName)"
            case .unableToLoadJSONData(let error):
                return "Unable to load json data.  Wrapped Error: \(error.localizedDescription)"
            case .unableToDecodeJSONData(wrappedError: let error):
                return "Unable to load decoded json data.  Wrapped Error: \(error.localizedDescription)"
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
            case .unableToFindFile(let fileName):
                return "Verify that the fileName: \(fileName) is spelled correclty or exists inside Bundle"
            case .unableToLoadJSONData:
                return "Verify that the file can be loaded as String Data"
            case .unableToDecodeJSONData:
                return "Verify that your Codable types match what is contained in the json file"
            }
        }
        
        // MARK: - <Equatable>
        
        public static func == (lhs: FileLoader.Error, rhs: FileLoader.Error) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
    }
}
