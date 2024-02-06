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

extension HTTPURLResponse: Printable {
    // MARK: - <Printable>
    
    public func print(_ printType: PrintType) -> String {
        switch printType {
        case .lite:
            return liteDescription()
        case .verbose:
            return verboseDescription()
        case .raw:
            return "HTTPURLResponse:\n\(description)"
        }
    }
    
    // MARK: - Private methods
    
    private func liteDescription() -> String {
        return """
        
        HTTPURLResponse:
        \(url?.absoluteString ?? String.empty)
        Status Code: \(statusCode)
        \(prettyPrint(dictionary: allHeaderFields, title: "HTTP Headers"))
        
        """
    }
    
    private func verboseDescription() -> String {
        return """
        
        HTTPURLResponse:
        URL: \(url?.absoluteString ?? "N/A")
        Status Code: \(statusCode)
        \(prettyPrint(dictionary: allHeaderFields, title: "HTTP Headers"))
        Expected content length: \(expectedContentLength)
        Suggested filename: \(suggestedFilename ?? "N/A")
        MIME type: \(mimeType ?? "N/A")
        Text encoding name: \(textEncodingName ?? "N/A")
        
        """
    }
    
    private func prettyPrint(dictionary: [AnyHashable: Any]?,
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
    
    private func prettyDictionary(dictionary: [AnyHashable: Any]) -> String? {
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
