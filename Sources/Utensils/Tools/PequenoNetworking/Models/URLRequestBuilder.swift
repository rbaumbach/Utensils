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
    func build(urlRequestInfo: URLRequestInfo) -> Result<URLRequest, PequenoNetworking.Error>
}

open class URLRequestBuilder: URLRequestBuilderProtocol {
    // MARK: - Private properties
    
    private let jsonSerializationWrapper: JSONSerializationWrapperProtocol
    
    // MARK: - Init methods
    
    public init(jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper()) {
        self.jsonSerializationWrapper = jsonSerializationWrapper
    }
    
    // MARK: - Public methods
    
    public func build(urlRequestInfo: URLRequestInfo) -> Result<URLRequest, PequenoNetworking.Error> {
        guard var urlComponents = URLComponents(string: urlRequestInfo.baseURL) else {
            return .failure(.urlRequestError(info: urlRequestInfo))
        }
        
        urlComponents.path = urlRequestInfo.endpoint
        
        urlComponents.queryItems = urlRequestInfo.parameters?.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let urlComponentsURL = urlComponents.url else {
            return .failure(.urlRequestError(info: urlRequestInfo))
        }
        
        var urlRequest = URLRequest(url: urlComponentsURL)
        urlRequest.httpMethod = urlRequestInfo.httpMethod.rawValue
        
        urlRequestInfo.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = urlRequestInfo.body {
            guard let body = try? jsonSerializationWrapper.data(withJSONObject: body) else {
                return .failure(.urlRequestError(info: urlRequestInfo))
            }
            
            urlRequest.httpBody = body
        }
        
        return .success(urlRequest)
    }
}
