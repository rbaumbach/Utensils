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

public extension URLRequest {
    // MARK: - Public enums
    
    enum PrintType {
        case lite
        case verbose
    }
    
    // MARK: - Public properties
    
    @discardableResult
    func print(printType: PrintType = .lite,
               shouldAutoPrint: Bool = true) -> String {
        let printString: String
        
        switch printType {
        case .lite:
            printString = liteDescription()
        case .verbose:
            printString = verboseDescription()
        }
        
        if shouldAutoPrint {
            Swift.print(printString)
        }
        
        return printString
    }
    
    // MARK: - Private methods
    
    private func liteDescription() -> String {
        return """
        \(httpMethod ?? String.empty) \(url?.absoluteString ?? String.empty)
        \(prettyPrint(dictionary: allHTTPHeaderFields, title: "HTTP Headers"))
        \(prettyPrint(dictionaryData: httpBody, title: "HTTP Body"))
        """
    }
    
    private func verboseDescription() -> String {
        return """
        
        HTTP Method: \(httpMethod ?? "N/A")
        URL: \(url?.absoluteString ?? "N/A")
        \(prettyPrint(dictionary: allHTTPHeaderFields, title: "HTTP Headers"))
        \(prettyPrint(dictionaryData: httpBody, title: "HTTP Body"))
        Cache Policy: \(cachePolicy)
        Timeout Interval: \(timeoutInterval) seconds
        HTTP should handle cookies: \(httpShouldHandleCookies)
        HTTP should handle pipelining: \(httpShouldUsePipelining)
        Allows cellular access: \(allowsCellularAccess)
        
        """
    }
    
    private func prettyPrint(dictionary: [String: Any]?, 
                             title: String) -> String {
        let fullTitle = "\(title):"
        
        guard let dictionary = dictionary else {
            return "\(fullTitle) N/A"
        }
        
        guard let prettyDictionary = prettyDictionary(dictionary: dictionary) else {
            return "\(fullTitle) N/A"
        }
        
        return prettyDictionary
    }
    
    private func prettyPrint(dictionaryData: Data?, 
                             title: String) -> String {
        let fullTitle = "\(title):"
        
        guard let dictionaryData = dictionaryData else {
            return "\(fullTitle) N/A"
        }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: dictionaryData,
                                                                 options: []) as? [String: Any] else {
            return "\(fullTitle) N/A"
        }
        
        guard let prettyDictionary = prettyDictionary(dictionary: dictionary) else {
            return "\(fullTitle) N/A"
        }
        
        return prettyDictionary
    }
    
    private func prettyDictionary(dictionary: [String: Any]) -> String? {
        // Note: I found out that if you don't set a body for a URLRequest and you access allHTTPHeaderFields
        // it returns an empty dictionary instead of nil
        
        guard !dictionary.isEmpty else {
            return nil
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary,
                                                         options: .prettyPrinted) else {
            return nil
        }
        
        guard let dictionaryAsString = String(data: jsonData,
                                              encoding: .utf8) else {
            return nil
        }
                
        return dictionaryAsString
    }
}
