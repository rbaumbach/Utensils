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

public protocol NetworkingEngineProtocol {
    func get<T: Codable>(baseURL: String,
                         headers: [String: String]?,
                         endpoint: String,
                         parameters: [String: String]?,
                         completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func delete<T: Codable>(baseURL: String,
                            headers: [String: String]?,
                            endpoint: String,
                            parameters: [String: String]?,
                            completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    // MARK: - Verbs w/ body & no parameters
    
    func post<T: Codable>(baseURL: String,
                          headers: [String: String]?,
                          endpoint: String,
                          body: [String: Any]?,
                          completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func put<T: Codable>(baseURL: String,
                         headers: [String: String]?,
                         endpoint: String,
                         body: [String: Any]?,
                         completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
    
    func patch<T: Codable>(baseURL: String,
                           headers: [String: String]?,
                           endpoint: String,
                           body: [String: Any]?,
                           completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void)
}

public class NetworkingEngine: NetworkingEngineProtocol {
    // MARK: - Private properties
    
    private let urlRequestBuilder: URLRequestBuilderProtocol
    private let urlSessionExecutor: URLSessionExecutorProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Init methods
    
    public init(urlRequestBuilder: URLRequestBuilderProtocol = URLRequestBuilder(),
                urlSessionExecutor: URLSessionExecutorProtocol = URLSessionExecutor(),
                jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
                dispatchQueueWraper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.urlRequestBuilder = urlRequestBuilder
        self.urlSessionExecutor = urlSessionExecutor
        self.jsonDecoder = jsonDecoder
        self.dispatchQueueWrapper = dispatchQueueWraper
    }
    
    // MARK: - Public methods
            
    public func get<T: Codable>(baseURL: String,
                                headers: [String: String]?,
                                endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .get,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeRequest(baseURL: baseURL,
                              headers: headers,
                              urlRequestInfo: urlRequestInfo) { [weak self] result in
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    public func delete<T: Codable>(baseURL: String,
                                   headers: [String: String]?,
                                   endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .delete,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeRequest(baseURL: baseURL,
                              headers: headers,
                              urlRequestInfo: urlRequestInfo,
                              completionHandler: completionHandler)
    }
            
    public func post<T: Codable>(baseURL: String,
                                 headers: [String: String]?,
                                 endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .post,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeRequest(baseURL: baseURL,
                              headers: headers,
                              urlRequestInfo: urlRequestInfo) { [weak self] result in
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    public func put<T: Codable>(baseURL: String,
                                headers: [String: String]?,
                                endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .put,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeRequest(baseURL: baseURL,
                              headers: headers,
                              urlRequestInfo: urlRequestInfo) { [weak self] result in
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    public func patch<T: Codable>(baseURL: String,
                                  headers: [String: String]?,
                                  endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(httpMethod: .patch,
                                            endpoint: endpoint,
                                            parameters: nil,
                                            body: body)
        
        executeRequest(baseURL: baseURL,
                              headers: headers,
                              urlRequestInfo: urlRequestInfo) { [weak self] result in
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func executeRequest<T: Codable>(baseURL: String,
                                            headers: [String: String]?,
                                            urlRequestInfo: URLRequestInfo,
                                            completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        urlRequestBuilder.build(baseURL: baseURL,
                                headers: headers,
                                urlRequestInfo: urlRequestInfo) { result in
            switch result {
            case .success(let urlRequest):
                urlSessionExecutor.execute(urlRequest: urlRequest) { [weak self] data, error in
                    self?.handleResponse(data: data,
                                         error: error,
                                         completionHandler: completionHandler)
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func handleResponse<T: Codable>(data: Data?,
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
}
