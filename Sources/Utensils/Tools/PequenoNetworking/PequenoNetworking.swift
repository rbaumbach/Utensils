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

public protocol PequenoNetworkingProtocol {
    func request(httpMethod: HTTPMethod,
                 endpoint: String,
                 headers: [String: String]?,
                 parameters: [String: String]?,
                 completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    func requestAndDeserialize<T: Codable>(httpMethod: HTTPMethod,
                                           endpoint: String,
                                           headers: [String: String]?,
                                           parameters: [String: String]?,
                                           completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
}

public class PequenoNetworking: PequenoNetworkingProtocol {
    // MARK: - Private properties
    
    private let urlSession: URLSessionProtocol
    private let jsonSerializationWrapper: JSONSerializationWrapperProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Readonly properties
    
    public let baseURL: String
    
    // MARK: - Init methods
    
    public init(baseURL: String,
                urlSession: URLSessionProtocol = URLSession.shared,
                jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper(),
                jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
                dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonSerializationWrapper = jsonSerializationWrapper
        self.jsonDecoder = jsonDecoder
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    // MARK: - Public methods
    
    public func request(httpMethod: HTTPMethod,
                        endpoint: String,
                        headers: [String: String]?,
                        parameters: [String: String]?,
                        completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        requestData(httpMethod: httpMethod,
                    endpoint: endpoint,
                    headers: headers,
                    parameters: parameters) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                let result: Result<Any, PequenoNetworking.Error> = Result.failure(error)
                                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let data = data else {
                let result: Result<Any, PequenoNetworking.Error> = Result.failure(.dataError)
 
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            let result: Result<Any, PequenoNetworking.Error>
            
            do {
                let jsonResponse = try jsonSerializationWrapper.jsonObject(with: data,
                                                                           options: .mutableContainers)
                
                result = Result.success(jsonResponse)
            } catch {
                result = Result.failure(.jsonObjectDecodeError(wrappedError: error))
            }
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    public func requestAndDeserialize<T: Codable>(httpMethod: HTTPMethod,
                                                  endpoint: String,
                                                  headers: [String: String]?,
                                                  parameters: [String: String]?,
                                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        requestData(httpMethod: httpMethod,
                    endpoint: endpoint,
                    headers: headers,
                    parameters: parameters) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                let result: Result<T, PequenoNetworking.Error> = Result.failure(error)
                                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let data = data else {
                let result: Result<T, PequenoNetworking.Error> = Result.failure(.dataError)
 
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            let result: Result<T, PequenoNetworking.Error>
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                
                result = Result.success(decodedData)
            } catch {
                result = Result.failure(.jsonDecodeError(wrappedError: error))
            }
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func constructURLRequest(httpMethod: HTTPMethod,
                                     baseURL: String,
                                     endpoint: String,
                                     headers: [String: String]?,
                                     parameters: [String: String]?) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
        
        urlComponents.queryItems = parameters?.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let urlComponentsURL = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: urlComponentsURL)
        urlRequest.httpMethod = httpMethod.rawValue
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func requestData(httpMethod: HTTPMethod,
                             endpoint: String,
                             headers: [String: String]?,
                             parameters: [String: String]?,
                             completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let urlRequest = constructURLRequest(httpMethod: httpMethod,
                                                   baseURL: baseURL,
                                                   endpoint: endpoint,
                                                   headers: headers,
                                                   parameters: parameters) else {
            let requestError = buildRequestError(httpMethod: httpMethod,
                                                 endpoint: endpoint,
                                                 headers: headers,
                                                 parameters: parameters)
            
            completionHandler(nil, requestError)
            
            return
        }
        
        let dataTask: URLSessionDataTaskProtocol = urlSession.dataTask(with: urlRequest) { data, response, error in
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
        
        dataTask.resume()
    }
    
    private func buildRequestError(httpMethod: HTTPMethod,
                                   endpoint: String,
                                   headers: [String: String]?,
                                   parameters: [String: String]?) -> PequenoNetworking.Error {
        let paramsString: String = {
            if let parameters = parameters {
                return parameters.description
            } else {
                return "N/A"
            }
        }()
        
        let headersString: String = {
            if let headers = headers {
                return headers.description
            } else {
                return "N/A"
            }
        }()
        
        let requestString = """
        \(httpMethod.rawValue) - \(baseURL)\(endpoint)
        Parameters: \(paramsString)
        Headers: \(headersString)
        """
        
        return .requestError(requestString)
    }
}
