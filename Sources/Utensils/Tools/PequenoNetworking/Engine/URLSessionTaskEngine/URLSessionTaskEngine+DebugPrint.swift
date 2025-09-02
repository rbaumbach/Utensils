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
    struct DebugPrint {
        // MARK: - Enums
        
        public enum Option: CaseIterable {
            case none
            case request
            case response
            case all
            
            var printsRequest: Bool {
                return self == .request || self == .all
            }
            
            var printsResponse: Bool {
                return self == .response || self == .all
            }
        }
        
        // MARK: - Readonly properties
        
        let option: Option
        let printer: Printer
        
        // MARK: - Init methods
        
        public init(option: Option, printer: Printer) {
            self.option = option
            self.printer = printer
        }
        
        // MARK: - Public methods
        
        public func print(request: URLRequest) {
            guard option.printsRequest else { return }
            
            printer.print(value: request)
        }

        public func print(response: URLResponse) {
            guard option.printsResponse else { return }

            if let httpResponse = response as? HTTPURLResponse {
                printer.print(value: httpResponse)
            } else {
                var warningMessage = "[URLSessionTaskEngine - [Warning] Received non-HTTP response: \(type(of: response)). "
                warningMessage += "Falling back to basic response printing"
                
                Swift.print(warningMessage)
                Swift.print(response)
            }
        }
    }
}
