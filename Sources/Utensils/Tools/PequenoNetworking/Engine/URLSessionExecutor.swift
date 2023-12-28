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

public protocol URLSessionExecutorProtocol {
    func execute(urlRequest: URLRequest,
                 completionHandler: @escaping (Data?, PequenoNetworking.Error?) -> Void)
}

public class URLSessionExecutor: URLSessionExecutorProtocol {
    // MARK: - Private properties
    
    private let urlSession: URLSessionProtocol
    
    // MARK: - Readonly properties
    
    public private(set) var lastExecutedDataTask: URLSessionDataTaskProtocol?
    
    // MARK: - Init methods
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func execute(urlRequest: URLRequest,
                        completionHandler: @escaping (Data?, PequenoNetworking.Error?) -> Void) {
        lastExecutedDataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(nil, .dataTaskError(wrappedError: error))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(nil, .malformedResponseError)
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(nil, .invalidStatusCodeError(statusCode: response.statusCode))
                
                return
            }
            
            completionHandler(data, nil)
        }
        
        lastExecutedDataTask?.resume()
    }
}
