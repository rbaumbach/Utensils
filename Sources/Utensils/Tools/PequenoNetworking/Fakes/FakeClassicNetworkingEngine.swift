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

public class FakeClassicNetworkingEngine: ClassicNetworkingEngineProtocol {
    // MARK: - Captured properties
    
    public var capturedGetBaseURL: String?
    public var capturedGetHeaders: [String: String]?
    public var capturedGetEndpoint: String?
    public var capturedGetParameters: [String: String]?
    public var capturedGetCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedDeleteBaseURL: String?
    public var capturedDeleteHeaders: [String: String]?
    public var capturedDeleteEndpoint: String?
    public var capturedDeleteParameters: [String: String]?
    public var capturedDeleteCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPostBaseURL: String?
    public var capturedPostHeaders: [String: String]?
    public var capturedPostEndpoint: String?
    public var capturedPostBody: [String: Any]?
    public var capturedPostCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPutBaseURL: String?
    public var capturedPutHeaders: [String: String]?
    public var capturedPutEndpoint: String?
    public var capturedPutBody: [String: Any]?
    public var capturedPutCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPatchBaseURL: String?
    public var capturedPatchHeaders: [String: String]?
    public var capturedPatchEndpoint: String?
    public var capturedPatchBody: [String: Any]?
    public var capturedPatchCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    // MARK: - Stubbed properties
        
    public var stubbedGetResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedDeleteResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPostResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPutResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPatchResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    
    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public init() { }
    
    // MARK: - <ClassicNetworkingEngineProtocol>
    
    public func get(baseURL: String,
                    headers: [String: String]?,
                    endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedGetBaseURL = baseURL
        capturedGetHeaders = headers
        capturedGetEndpoint = endpoint
        capturedGetParameters = parameters
        capturedGetCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedGetResult)
        }
    }
    
    public func delete(baseURL: String,
                       headers: [String: String]?,
                       endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedDeleteBaseURL = baseURL
        capturedDeleteHeaders = headers
        capturedDeleteEndpoint = endpoint
        capturedDeleteParameters = parameters
        capturedDeleteCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedDeleteResult)
        }
    }
    
    public func post(baseURL: String,
                     headers: [String: String]?,
                     endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPostBaseURL = baseURL
        capturedPostHeaders = headers
        capturedPostEndpoint = endpoint
        capturedPostBody = body
        capturedPostCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPostResult)
        }
    }
    
    public func put(baseURL: String,
                    headers: [String: String]?,
                    endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPutBaseURL = baseURL
        capturedPutHeaders = headers
        capturedPutEndpoint = endpoint
        capturedPutBody = body
        capturedPutCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPutResult)
        }
    }
    
    public func patch(baseURL: String,
                      headers: [String: String]?,
                      endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPatchBaseURL = baseURL
        capturedPatchHeaders = headers
        capturedPatchEndpoint = endpoint
        capturedPatchBody = body
        capturedPatchCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPatchResult)
        }
    }
}
