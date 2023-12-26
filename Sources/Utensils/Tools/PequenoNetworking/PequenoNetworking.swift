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
    // MARK: - JSONSerialization (ol' skoo)
    
    func get(endpoint: String,
             parameters: [String: String]?,
             completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    func delete(endpoint: String,
                parameters: [String: String]?,
                completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    func post(endpoint: String,
              body: [String: Any]?,
              completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    func put(endpoint: String,
             body: [String: Any]?,
             completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    func patch(endpoint: String,
               body: [String: Any]?,
               completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void)
    
    // MARK: - Codable
    
    func get<T: Codable>(endpoint: String,
                         parameters: [String: String]?,
                         completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func delete<T: Codable>(endpoint: String,
                            parameters: [String: String]?,
                            completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func post<T: Codable>(endpoint: String,
                          body: [String: Any]?,
                          completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func put<T: Codable>(endpoint: String,
                         body: [String: Any]?,
                         completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func patch<T: Codable>(endpoint: String,
                           body: [String: Any]?,
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
    public let headers: [String: String]?
    
    // MARK: - Init methods
    
    public init(baseURL: String,
                headers: [String: String]?,
                urlSession: URLSessionProtocol = URLSession.shared,
                jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper(),
                jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
                dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.baseURL = baseURL
        self.headers = headers
        self.urlSession = urlSession
        self.jsonSerializationWrapper = jsonSerializationWrapper
        self.jsonDecoder = jsonDecoder
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    public convenience init() {
        guard let baseURL = UserDefaults.standard.string(forKey: PequenoNetworkingConstants.BaseURLKey) else {
            preconditionFailure("BaseURL must exist in UserDefaults")
        }
        
        let headers = UserDefaults.standard.object(forKey: PequenoNetworkingConstants.HeadersKey) as? [String: String]
        
        self.init(baseURL: baseURL, headers: headers)
    }
    
    // MARK: - Public methods
    
    public func get(endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .get,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func delete(endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .delete,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func post(endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .post,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func put(endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .put,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func patch(endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .patch,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
        
    public func get<T: Codable>(endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .get,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func delete<T: Codable>(endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .delete,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func post<T: Codable>(endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .post,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func put<T: Codable>(endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .put,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    public func patch<T: Codable>(endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .patch,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeNetworkRequest(urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
        
    private func buildURLRequest(urlRequestInfo: URLRequestInfo,
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
            guard let body = try? JSONSerialization.data(withJSONObject: body) else {
                completionHandler(.failure(.urlRequestError(info: urlRequestInfo)))
                
                return
            }
            
            urlRequest.httpBody = body
        }
        
        completionHandler(.success(urlRequest))
    }
    
    // MARK: - JSONSerialization (ol' skoo)
    
    private func executeNetworkRequest(urlRequestInfo: URLRequestInfo,
                                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        
        buildURLRequest(urlRequestInfo: urlRequestInfo) { result in
            switch result {
            case .success(let urlRequest):
                executeJSONSerializer(urlRequest: urlRequest,
                                      completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func executeJSONSerializer(urlRequest: URLRequest,
                                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        buildAndExecute(urlRequest: urlRequest) { [weak self] data, error in
            self?.handleResponseWithJSONSerializer(data: data, error: error) { [weak self] result in
                self?.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
        }
    }
    
    private func handleResponseWithJSONSerializer(data: Data?,
                                                  error: PequenoNetworking.Error?,
                                                  completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
            
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(.dataError))
            
            return
        }
        
        let result: Result<Any, PequenoNetworking.Error>
        
        do {
            let jsonResponse = try self.jsonSerializationWrapper.jsonObject(with: data,
                                                                            options: .mutableContainers)
            
            result = .success(jsonResponse)
        } catch {
            result = .failure(.jsonObjectDecodeError(wrappedError: error))
        }
        
        completionHandler(result)
    }
    
    // MARK: - Codable
    
    private func executeNetworkRequest<T: Codable>(urlRequestInfo: URLRequestInfo,
                                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        
        buildURLRequest(urlRequestInfo: urlRequestInfo) { result in
            switch result {
            case .success(let urlRequest):
                executeCodable(urlRequest: urlRequest,
                               completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func executeCodable<T: Codable>(urlRequest: URLRequest,
                                            completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        buildAndExecute(urlRequest: urlRequest) { [weak self] data, error in
            self?.handleResponseOnCodable(data: data, error: error) { [weak self] result in
                self?.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
        }
    }
    
    private func handleResponseOnCodable<T: Codable>(data: Data?,
                                                     error: PequenoNetworking.Error?,
                                                     completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
            
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(.dataError))
            
            return
        }
        
        let result: Result<T, PequenoNetworking.Error>
        
        do {
            let jsonResponse = try self.jsonDecoder.decode(T.self, from: data)
            
            result = .success(jsonResponse)
        } catch {
            result = .failure(.jsonObjectDecodeError(wrappedError: error))
        }
        
        completionHandler(result)
    }
    
    // MARK: - URLSession execution
    
    private func buildAndExecute(urlRequest: URLRequest,
                                 completionHandler: @escaping (Data?, PequenoNetworking.Error?) -> Void) {
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
}
