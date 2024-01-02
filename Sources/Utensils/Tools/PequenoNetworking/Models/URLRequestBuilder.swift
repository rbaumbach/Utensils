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

public protocol URLRequestBuilderProtocol {
    func build(baseURL: String,
               headers: [String: String]?,
               urlRequestInfo: URLRequestInfo,
               completionHandler: (Result<URLRequest, PequenoNetworking.Error>) -> Void)
}

public class URLRequestBuilder: URLRequestBuilderProtocol {
    // MARK: - Private properties
    
    private let jsonSerializationWrapper: JSONSerializationWrapperProtocol
    
    // MARK: - Init methods
    
    public init(jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper()) {
        self.jsonSerializationWrapper = jsonSerializationWrapper
    }
    
    // MARK: - Public methods
    
    public func build(baseURL: String,
                      headers: [String: String]?,
                      urlRequestInfo: URLRequestInfo,
                      completionHandler: (Result<URLRequest, PequenoNetworking.Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completionHandler(.failure(.urlRequestError(info: urlRequestInfo)))
            
            return
        }
        
        urlComponents.path = urlRequestInfo.endpoint
        
        urlComponents.queryItems = urlRequestInfo.parameters?.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let urlComponentsURL = urlComponents.url else {
            completionHandler(.failure(.urlRequestError(info: urlRequestInfo)))
            
            return
        }
        
        var urlRequest = URLRequest(url: urlComponentsURL)
        urlRequest.httpMethod = urlRequestInfo.httpMethod.rawValue
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = urlRequestInfo.body {
            guard let body = try? jsonSerializationWrapper.data(withJSONObject: body) else {
                completionHandler(.failure(.urlRequestError(info: urlRequestInfo)))
                
                return
            }
            
            urlRequest.httpBody = body
        }
        
        completionHandler(.success(urlRequest))
    }
}
