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

public protocol URLSessionTaskEngineProtocol {
    @discardableResult
    func dataTask(urlRequest: URLRequest,
                  completionHandler: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionTaskProtocol
    
    @discardableResult
    func downloadTask(urlRequest: URLRequest,
                      completionHandler: @escaping (Result<URL, Swift.Error>) -> Void) -> URLSessionTaskProtocol
    
    @discardableResult
    func uploadTask(urlRequest: URLRequest,
                    data: Data,
                    completionHandler: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionTaskProtocol
}

open class URLSessionTaskEngine: URLSessionTaskEngineProtocol {
    // MARK: - Private properties
    
    private let shouldExecuteTasksImmediately: Bool
    private let urlSession: URLSessionProtocol
    private let userDefaults: UserDefaultsProtocol
    
    // MARK: - Readonly properties
    
    public private(set) var lastExecutedURLSessionTask: URLSessionTaskProtocol?
    
    // MARK: - Public properties
    
    public var enableURLRequestPrinting: Bool {
        get {
            return userDefaults.bool(forKey: PequenoNetworking.Constants.EnableURLRequestPrintingKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: PequenoNetworking.Constants.EnableURLRequestPrintingKey)
        }
    }
    
    // MARK: - Init methods
    
    public init(shouldExecuteTasksImmediately: Bool = true,
                urlSession: URLSessionProtocol = URLSession.shared,
                userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.shouldExecuteTasksImmediately = shouldExecuteTasksImmediately
        self.urlSession = urlSession
        self.userDefaults = userDefaults
    }
    
    @discardableResult
    public func dataTask(urlRequest: URLRequest,
                         completionHandler: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionTaskProtocol {
        if enableURLRequestPrinting {
            urlRequest.print()
        }
        
        let dataTask = urlSession.dataTask(urlRequest: urlRequest) { [weak self] data, response, error in
            self?.handleSessionTask(item: data,
                                    response: response,
                                    error: error,
                                    completionHandler: completionHandler)
        }
        
        if shouldExecuteTasksImmediately {
            dataTask.resume()
        }
        
        lastExecutedURLSessionTask = dataTask
        
        return dataTask
    }
    
    @discardableResult
    public func downloadTask(urlRequest: URLRequest,
                             completionHandler: @escaping (Result<URL, Swift.Error>) -> Void) -> URLSessionTaskProtocol {
        if enableURLRequestPrinting {
            urlRequest.print()
        }
        
        let downloadTask = urlSession.downloadTask(urlRequest: urlRequest) { [weak self] tempURL, response, error in
            self?.handleSessionTask(item: tempURL,
                                    response: response,
                                    error: error,
                                    completionHandler: completionHandler)
        }
        
        if shouldExecuteTasksImmediately {
            downloadTask.resume()
        }
        
        lastExecutedURLSessionTask = downloadTask
        
        return downloadTask
    }
    
    @discardableResult
    public func uploadTask(urlRequest: URLRequest,
                           data: Data,
                           completionHandler: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionTaskProtocol {
        if enableURLRequestPrinting {
            urlRequest.print()
        }
        
        let uploadTask = urlSession.uploadTask(urlRequest: urlRequest,
                                               from: data) { [weak self] data, response, error in
            self?.handleSessionTask(item: data,
                                    response: response,
                                    error: error,
                                    completionHandler: completionHandler)
        }
        
        if shouldExecuteTasksImmediately {
            uploadTask.resume()
        }
        
        lastExecutedURLSessionTask = uploadTask
        
        return uploadTask
    }
    
    // MARK: - Private methods
    
    private func handleSessionTask<T>(item: T?,
                                      response: URLResponse?,
                                      error: Swift.Error?,
                                      completionHandler: (Result<T, Swift.Error>) -> Void) {
        let result = validateResponse(item: item,
                                      response: response,
                                      error: error)
        
        completionHandler(result)
    }
    
    private func validateResponse<T>(item: T?,
                                     response: URLResponse?,
                                     error: Swift.Error?) -> Result<T, Swift.Error> {
        if let error = error {
            return .failure(error)
        }
        
        guard let response = response as? HTTPURLResponse else {
            let sesssionError = Error<T>.invalidSessionResponse as Swift.Error
            
            return .failure(sesssionError)
        }
        
        guard (200...299).contains(response.statusCode) else {
            let sesssionError = Error<T>.invalidStatusCode(statusCode: response.statusCode) as Swift.Error
            
            return .failure(sesssionError)
        }
        
        guard let item = item else {
            let sessionError = Error<T>.invalidSessionItem(type: T.self) as Swift.Error
            
            return .failure(sessionError)
        }
        
        return .success(item)
    }
}
