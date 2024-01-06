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

// Note: Any? is used for the capturedCompletionHandlers due to warning messages about "shadowing" at the
// class level. As a consumer you can cast to (Result<T, PequenoNetworking.Error>) -> Void).

public class FakePequenoNetworking: PequenoNetworkingProtocol {
    // MARK: - Captured properties
    
    // MARK: - JSONSerialization (ol' skoo)
    
    public var capturedGetEndpoint: String?
    public var capturedGetParameters: [String: String]?
    public var capturedGetCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedDeleteEndpoint: String?
    public var capturedDeleteParameters: [String: String]?
    public var capturedDeleteCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPostEndpoint: String?
    public var capturedPostBody: [String: Any]?
    public var capturedPostCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPutEndpoint: String?
    public var capturedPutBody: [String: Any]?
    public var capturedPutCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    public var capturedPatchEndpoint: String?
    public var capturedPatchBody: [String: Any]?
    public var capturedPatchCompletionHandler: ((Result<Any, PequenoNetworking.Error>) -> Void)?
    
    // MARK: - Codable
    
    public var capturedCodableGetEndpoint: String?
    public var capturedCodableGetParameters: [String: String]?
    public var capturedCodableGetCompletionHandler: Any?
    
    public var capturedCodableDeleteEndpoint: String?
    public var capturedCodableDeleteParameters: [String: String]?
    public var capturedCodableDeleteCompletionHandler: Any?
    
    public var capturedCodablePostEndpoint: String?
    public var capturedCodablePostBody: [String: Any]?
    public var capturedCodablePostCompletionHandler: Any?
    
    public var capturedCodablePutEndpoint: String?
    public var capturedCodablePutBody: [String: Any]?
    public var capturedCodablePutCompletionHandler: Any?
    
    public var capturedCodablePatchEndpoint: String?
    public var capturedCodablePatchBody: [String: Any]?
    public var capturedCodablePatchCompletionHandler: Any?
    
    // MARK: - Stubbed properties
    
    // MARK: - JSONSerialization (ol' skoo)
    
    public var stubbedGetResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedDeleteResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPostResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPutResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPatchResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    
    // MARK: - Codable
    
    public var stubbedCodableGetResult: Any = Result<Any, PequenoNetworking.Error>.success("Éxito")
    public var stubbedCodableDeleteResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedCodablePostResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedCodablePutResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedCodablePatchResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    
    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public init() { }
    
    // MARK: - <PequenoNetworkingProtocol>
    
    // MARK: - JSONSerialization (ol' skoo)
    
    public func get(endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedGetEndpoint = endpoint
        capturedGetParameters = parameters
        capturedGetCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedGetResult)
        }
    }
    
    public func delete(endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedDeleteEndpoint = endpoint
        capturedDeleteParameters = parameters
        capturedDeleteCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedDeleteResult)
        }
    }
    
    public func post(endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPostEndpoint = endpoint
        capturedPostBody = body
        capturedPostCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPostResult)
        }
    }
    
    public func put(endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPutEndpoint = endpoint
        capturedPutBody = body
        capturedPutCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPutResult)
        }
    }
    
    public func patch(endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        capturedPatchEndpoint = endpoint
        capturedPatchBody = body
        capturedPatchCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedPatchResult)
        }
    }
    
    // MARK: - Codable
    
    public func get<T: Codable>(endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedCodableGetEndpoint = endpoint
        capturedCodableGetParameters = parameters
        capturedCodableGetCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedGetResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable get result success value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func delete<T: Codable>(endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedCodableDeleteEndpoint = endpoint
        capturedCodableDeleteParameters = parameters
        capturedCodableDeleteCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedDeleteResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable delete result success value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func post<T: Codable>(endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedCodablePostEndpoint = endpoint
        capturedCodablePostBody = body
        capturedCodablePostCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPostResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable post result success value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func put<T: Codable>(endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedCodablePutEndpoint = endpoint
        capturedCodablePutBody = body
        capturedCodablePutCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPutResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable put result success value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func patch<T: Codable>(endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedCodablePatchEndpoint = endpoint
        capturedCodablePatchBody = body
        capturedCodablePatchCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPatchResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable patch result success value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
}
