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

extension URLSessionTaskEngine {
    public struct DebugPrint {
        // MARK: - Enums
        
        public enum Option: CaseIterable {
            case none
            case request
            case response
            case all
        }
        
        // MARK: - Private properties
        
        private let option: Option
        private let printType: PrintType
        
        // MARK: - Init methods
        
        public init(option: Option, printType: PrintType) {
            self.option = option
            self.printType = printType
        }
        
        // MARK: - Public methods
        
        public func print<T: Printable>(value: T?) {
            guard let value = value else { return }
            
            if let urlRequest = value as? URLRequest {
                switch option {
                case .all, .request:
                    urlRequest.print(printType)
                default:
                    break
                }
            } else if let httpURLResponse = value as? HTTPURLResponse {
                switch option {
                case .all, .response:
                    httpURLResponse.print(printType)
                default:
                    break
                }
            }
        }
    }
}
