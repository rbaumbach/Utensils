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

// Note: Any? is used for the capturedCompletionHandlers due to warning messages about "shadowing" at the
// class level. As a consumer you can cast to (Result<T, PequenoNetworking.Error>) -> Void).

open class FakeNetworkingEngine: Fake, NetworkingEngineProtocol {
    // MARK: - Captured properties
    
    public var capturedGetBaseURL: String?
    public var capturedGetHeaders: [String: String]?
    public var capturedGetEndpoint: String?
    public var capturedGetParameters: [String: String]?
    public var capturedGetCompletionHandler: Any?
    
    public var capturedDeleteBaseURL: String?
    public var capturedDeleteHeaders: [String: String]?
    public var capturedDeleteEndpoint: String?
    public var capturedDeleteParameters: [String: String]?
    public var capturedDeleteCompletionHandler: Any?
    
    public var capturedPostBaseURL: String?
    public var capturedPostHeaders: [String: String]?
    public var capturedPostEndpoint: String?
    public var capturedPostBody: [String: Any]?
    public var capturedPostCompletionHandler: Any?
    
    public var capturedPutBaseURL: String?
    public var capturedPutHeaders: [String: String]?
    public var capturedPutEndpoint: String?
    public var capturedPutBody: [String: Any]?
    public var capturedPutCompletionHandler: Any?
    
    public var capturedPatchBaseURL: String?
    public var capturedPatchHeaders: [String: String]?
    public var capturedPatchEndpoint: String?
    public var capturedPatchBody: [String: Any]?
    public var capturedPatchCompletionHandler: Any?
    
    public var capturedDownloadFileBaseURL: String?
    public var capturedDownloadFileHeaders: [String: String]?
    public var capturedDownloadFileEndpoint: String?
    public var capturedDownloadFileParameters: [String: String]?
    public var capturedDownloadFileFilename: String?
    public var capturedDownloadFileDirectory: DirectoryProtocol?
    public var capturedDownloadFileCompletionHandler: ((Result<URL, PequenoNetworking.Error>) -> Void)?
    
    public var capturedUploadFileBaseURL: String?
    public var capturedUploadFileHeaders: [String: String]?
    public var capturedUploadFileEndpoint: String?
    public var capturedUploadFileParameters: [String: String]?
    public var capturedUploadFileData: Data?
    public var capturedUploadFileCompletionHandler: Any?
    
    // MARK: - Stubbed properties
    
    public var stubbedGetResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedDeleteResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPostResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPutResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedPatchResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    public var stubbedDownloadFileResult: Result<URL, PequenoNetworking.Error> = {
       let url = URL(string: "https://99-stubby-99.party")!
        
        return .success(url)
    }()
    public var stubbedUploadFileResult: Result<Any, PequenoNetworking.Error> = .success("Éxito")
    
    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public override init() { }
    
    // MARK: - <NetworkingEngineProtocol>
    
    public func get<T: Codable>(baseURL: String,
                                headers: [String: String]?,
                                endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedGetBaseURL = baseURL
        capturedGetHeaders = headers
        capturedGetEndpoint = endpoint
        capturedGetParameters = parameters
        capturedGetCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedGetResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable get result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func delete<T: Codable>(baseURL: String,
                                   headers: [String: String]?,
                                   endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedDeleteBaseURL = baseURL
        capturedDeleteHeaders = headers
        capturedDeleteEndpoint = endpoint
        capturedDeleteParameters = parameters
        capturedDeleteCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedDeleteResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable delete result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func post<T: Codable>(baseURL: String,
                                 headers: [String: String]?,
                                 endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedPostBaseURL = baseURL
        capturedPostHeaders = headers
        capturedPostEndpoint = endpoint
        capturedPostBody = body
        capturedPostCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPostResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable post result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func put<T: Codable>(baseURL: String,
                                headers: [String: String]?,
                                endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedPutBaseURL = baseURL
        capturedPutHeaders = headers
        capturedPutEndpoint = endpoint
        capturedPutBody = body
        capturedPutCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPutResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable put result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func patch<T: Codable>(baseURL: String,
                                  headers: [String: String]?,
                                  endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedPatchBaseURL = baseURL
        capturedPatchHeaders = headers
        capturedPatchEndpoint = endpoint
        capturedPatchBody = body
        capturedPatchCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedPatchResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable patch result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func downloadFile(baseURL: String,
                             headers: [String: String]?,
                             endpoint: String,
                             parameters: [String: String]?,
                             filename: String,
                             directory: Directory,
                             completionHandler: @escaping (Result<URL, PequenoNetworking.Error>) -> Void) {
        capturedDownloadFileBaseURL = baseURL
        capturedDownloadFileHeaders = headers
        capturedDownloadFileEndpoint = endpoint
        capturedDownloadFileParameters = parameters
        capturedDownloadFileFilename = filename
        capturedDownloadFileDirectory = directory
        capturedDownloadFileCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedDownloadFileResult)
        }
    }
    
    public func uploadFile<T: Codable>(baseURL: String,
                                       headers: [String: String]?,
                                       endpoint: String,
                                       parameters: [String: String]?,
                                       data: Data,
                                       completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        capturedUploadFileBaseURL = baseURL
        capturedUploadFileHeaders = headers
        capturedUploadFileEndpoint = endpoint
        capturedUploadFileParameters = parameters
        capturedUploadFileData = data
        capturedUploadFileCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedUploadFileResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed codable upload result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
}
