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

public protocol PequenoNetworkingProtocol {
    // MARK: - JSONSerialization (ol' skoo)
    
    func get(endpoint: String,
             parameters: [String: String]?,
             completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func delete(endpoint: String,
                parameters: [String: String]?,
                completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func post(endpoint: String,
              body: [String: Any]?,
              completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func put(endpoint: String,
             body: [String: Any]?,
             completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func patch(endpoint: String,
               body: [String: Any]?,
               completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    // MARK: - Codable
    
    func get<T: Codable>(endpoint: String,
                         parameters: [String: String]?,
                         completionHandler: @escaping (Result<T, Error>) -> Void)
    
    func delete<T: Codable>(endpoint: String,
                            parameters: [String: String]?,
                            completionHandler: @escaping (Result<T, Error>) -> Void)
    
    func post<T: Codable>(endpoint: String,
                          body: [String: Any]?,
                          completionHandler: @escaping (Result<T, Error>) -> Void)
    
    func put<T: Codable>(endpoint: String,
                         body: [String: Any]?,
                         completionHandler: @escaping (Result<T, Error>) -> Void)
    
    func patch<T: Codable>(endpoint: String,
                           body: [String: Any]?,
                           completionHandler: @escaping (Result<T, Error>) -> Void)
    
    // MARK: - File transfers
    
    func downloadFile(endpoint: String,
                      parameters: [String: String]?,
                      filename: String,
                      directory: Directory,
                      completionHandler: @escaping (Result<URL, Error>) -> Void)
    
    func uploadFile(endpoint: String,
                    parameters: [String: String]?,
                    data: Data,
                    completionHandler: @escaping (Result<Any, Error>) -> Void)
    
    func uploadFile<T: Codable>(endpoint: String,
                                parameters: [String: String]?,
                                data: Data,
                                completionHandler: @escaping (Result<T, Error>) -> Void)
}

open class PequenoNetworking: PequenoNetworkingProtocol {
    // MARK: - Private properties
    
    private let classicNetworkingEngine: ClassicNetworkingEngineProtocol
    private let networkingEngine: NetworkingEngineProtocol
    private let userDefaults: UserDefaultsProtocol
    
    // MARK: - Readonly properties
    
    public let baseURL: String
    public let headers: [String: String]?
    
    // MARK: - Public properties
    
    public var enableURLRequestPrinting: Bool {
        get {
            return userDefaults.bool(forKey: Constants.EnableURLRequestPrintingKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: Constants.EnableURLRequestPrintingKey)
        }
    }
    
    // MARK: - Init methods
    
    public init(baseURL: String,
                headers: [String: String]? = nil,
                classicNetworkingEngine: ClassicNetworkingEngineProtocol = ClassicNetworkingEngine(),
                networkingEngine: NetworkingEngineProtocol = NetworkingEngine(),
                userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.baseURL = baseURL
        self.headers = headers
        self.classicNetworkingEngine = classicNetworkingEngine
        self.networkingEngine = networkingEngine
        self.userDefaults = userDefaults
    }
    
    public convenience init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        guard let baseURL = userDefaults.string(forKey: Constants.BaseURLKey) else {
            preconditionFailure("BaseURL must exist in UserDefaults")
        }
        
        let headers = userDefaults.object(forKey: Constants.HeadersKey) as? [String: String]
        
        self.init(baseURL: baseURL, headers: headers)
    }
    
    // MARK: - Public methods
    
    public func get(endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.get(baseURL: baseURL,
                                    headers: headers,
                                    endpoint: endpoint,
                                    parameters: parameters,
                                    completionHandler: completionHandler)
    }
    
    public func delete(endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.delete(baseURL: baseURL,
                                       headers: headers,
                                       endpoint: endpoint,
                                       parameters: parameters,
                                       completionHandler: completionHandler)
    }
    
    public func post(endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.post(baseURL: baseURL,
                                     headers: headers,
                                     endpoint: endpoint,
                                     body: body,
                                     completionHandler: completionHandler)
    }
    
    public func put(endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.put(baseURL: baseURL,
                                    headers: headers,
                                    endpoint: endpoint,
                                    body: body,
                                    completionHandler: completionHandler)
    }
    
    public func patch(endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.patch(baseURL: baseURL,
                                      headers: headers,
                                      endpoint: endpoint,
                                      body: body,
                                      completionHandler: completionHandler)
    }
    
    public func get<T: Codable>(endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.get(baseURL: baseURL,
                             headers: headers,
                             endpoint: endpoint,
                             parameters: parameters,
                             completionHandler: completionHandler)
    }
    
    public func delete<T: Codable>(endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.delete(baseURL: baseURL,
                                headers: headers,
                                endpoint: endpoint,
                                parameters: parameters,
                                completionHandler: completionHandler)
    }
    
    public func post<T: Codable>(endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.post(baseURL: baseURL,
                              headers: headers,
                              endpoint: endpoint,
                              body: body,
                              completionHandler: completionHandler)
    }
    
    public func put<T: Codable>(endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.put(baseURL: baseURL,
                             headers: headers,
                             endpoint: endpoint,
                             body: body,
                             completionHandler: completionHandler)
    }
    
    public func patch<T: Codable>(endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.patch(baseURL: baseURL,
                               headers: headers,
                               endpoint: endpoint,
                               body: body,
                               completionHandler: completionHandler)
    }
        
    public func downloadFile(endpoint: String,
                             parameters: [String: String]?,
                             filename: String,
                             directory: Directory,
                             completionHandler: @escaping (Result<URL, Error>) -> Void) {
        networkingEngine.downloadFile(baseURL: baseURL,
                                      headers: headers,
                                      endpoint: endpoint,
                                      parameters: parameters,
                                      filename: filename,
                                      directory: directory,
                                      completionHandler: completionHandler)
    }
    
    public func uploadFile(endpoint: String,
                           parameters: [String: String]?,
                           data: Data,
                           completionHandler: @escaping (Result<Any, Error>) -> Void) {
        classicNetworkingEngine.uploadFile(baseURL: baseURL,
                                           headers: headers,
                                           endpoint: endpoint,
                                           parameters: parameters,
                                           data: data,
                                           completionHandler: completionHandler)
    }
    
    public func uploadFile<T: Codable>(endpoint: String,
                                       parameters: [String: String]?,
                                       data: Data,
                                       completionHandler: @escaping (Result<T, Error>) -> Void) {
        networkingEngine.uploadFile(baseURL: baseURL,
                                    headers: headers,
                                    endpoint: endpoint,
                                    parameters: parameters,
                                    data: data,
                                    completionHandler: completionHandler)
    }
}
