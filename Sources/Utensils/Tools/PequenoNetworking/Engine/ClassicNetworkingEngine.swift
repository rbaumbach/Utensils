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

public protocol ClassicNetworkingEngineProtocol {
    var debugPrint: URLSessionTaskEngine.DebugPrint? { get set }
    
    func get(baseURL: String,
             headers: [String: String]?,
             endpoint: String,
             parameters: [String: String]?,
             completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func delete(baseURL: String,
                headers: [String: String]?,
                endpoint: String,
                parameters: [String: String]?,
                completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func post(baseURL: String,
              headers: [String: String]?,
              endpoint: String,
              body: [String: Any]?,
              completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func put(baseURL: String,
             headers: [String: String]?,
             endpoint: String,
             body: [String: Any]?,
             completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func patch(baseURL: String,
               headers: [String: String]?,
               endpoint: String,
               body: [String: Any]?,
               completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func uploadFile(baseURL: String,
                    headers: [String: String]?,
                    endpoint: String,
                    parameters: [String: String]?,
                    data: Data,
                    completionHandler: @escaping (Result<Any, Error>) -> Void)
}

open class ClassicNetworkingEngine: ClassicNetworkingEngineProtocol {
    // MARK: - Private properties
    
    private let urlRequestBuilder: URLRequestBuilderProtocol
    private var urlSessionTaskEngine: URLSessionTaskEngineProtocol
    private let jsonSerializationWrapper: JSONSerializationWrapperProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Public properties
    
    public var debugPrint: URLSessionTaskEngine.DebugPrint? {
        get {
            return urlSessionTaskEngine.debugPrint
        }
        
        set {
            urlSessionTaskEngine.debugPrint = newValue
        }
    }
    
    // MARK: - Init methods
    
    public init(urlRequestBuilder: URLRequestBuilderProtocol = URLRequestBuilder(),
                urlSessionTaskEngine: URLSessionTaskEngineProtocol = URLSessionTaskEngine(),
                jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper(),
                dispatchQueueWraper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.urlRequestBuilder = urlRequestBuilder
        self.urlSessionTaskEngine = urlSessionTaskEngine
        self.jsonSerializationWrapper = jsonSerializationWrapper
        self.dispatchQueueWrapper = dispatchQueueWraper
    }
    
    // MARK: - Public methods
    
    public func get(baseURL: String,
                    headers: [String: String]?,
                    endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .get,
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
    
    public func delete(baseURL: String,
                       headers: [String: String]?,
                       endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .delete,
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
    
    public func post(baseURL: String,
                     headers: [String: String]?,
                     endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .post,
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
    
    public func put(baseURL: String,
                    headers: [String: String]?,
                    endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .put,
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
    
    public func patch(baseURL: String,
                      headers: [String: String]?,
                      endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .patch,
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
    
    public func uploadFile(baseURL: String,
                           headers: [String: String]?,
                           endpoint: String,
                           parameters: [String: String]?,
                           data: Data,
                           completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let urlRequestInfo = URLRequestInfo(baseURL: baseURL,
                                            headers: headers,
                                            httpMethod: .post,
                                            endpoint: endpoint,
                                            parameters: parameters,
                                            body: nil)
        
        executeUploadRequest(urlRequestInfo: urlRequestInfo,
                             data: data) { [weak self] result in
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func executeRequest(baseURL: String,
                                headers: [String: String]?,
                                urlRequestInfo: URLRequestInfo,
                                completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let result = urlRequestBuilder.build(urlRequestInfo: urlRequestInfo)
        
        switch result {
        case .success(let urlRequest):
            urlSessionTaskEngine.dataTask(urlRequest: urlRequest) { [weak self] result in
                self?.handleResponse(result: result,
                                     completionHandler: completionHandler)
            }
        case .failure(let error):
            completionHandler(.failure(error))
        }
    }
    
    private func executeUploadRequest(urlRequestInfo: URLRequestInfo,
                                      data: Data,
                                      completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let result = urlRequestBuilder.build(urlRequestInfo: urlRequestInfo)
        
        switch result {
        case .success(let urlRequest):
            urlSessionTaskEngine.uploadTask(urlRequest: urlRequest,
                                            data: data) { [weak self] result in
                self?.handleResponse(result: result,
                                     completionHandler: completionHandler)
            }
        case .failure(let error):
            completionHandler(.failure(error))
        }
    }
    
    private func handleResponse(result: Result<Data, Error>,
                                completionHandler: @escaping (Result<Any, Error>) -> Void) {
        let result = result.flatMap { data in
            do {
                let jsonResponse = try self.jsonSerializationWrapper.jsonObject(with: data,
                                                                                options: .mutableContainers)
                
                return .success(jsonResponse)
            } catch {
                return .failure(error)
            }
        }
        
        completionHandler(result)
    }
}
