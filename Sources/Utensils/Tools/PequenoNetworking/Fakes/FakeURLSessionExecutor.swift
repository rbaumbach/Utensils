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

open class FakeURLSessionExecutor: Fake, URLSessionExecutorProtocol {
    // MARK: - Captured properties
    
    public var capturedExecuteURLRequest: URLRequest?
    public var capturedExecuteCompletionHandler: ((Result<Data, PequenoNetworking.Error>) -> Void)?
    
    public var capturedExecuteDownloadURLRequest: URLRequest?
    public var capturedExecuteDownloadCustomFilename: String?
    public var capturedExecuteDownloadDirectory: Directory?
    public var capturedExecuteDownloadCompletionHandler: ((Result<URL, PequenoNetworking.Error>) -> Void)?
    
    // MARK: - Stubbed properties
    
    public var stubbedExecuteTask: URLSessionTaskProtocol = FakeURLSessionTask()
    public var stubbedExecuteResult: Result<Data, PequenoNetworking.Error> = .success("Lucky Day".data(using: .utf8)!)
    
    public var stubbedExecuteDownloadTask: URLSessionTaskProtocol = FakeURLSessionTask()
    public var stubbedExecuteDownloadResult: Result<URL, PequenoNetworking.Error> = {
        let url = URL(string: "https://dusty-bottoms.3amigos-99.party")!
        
        return .success(url)
    }()

    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public override init() { }
    
    // MARK: - <URLSessionExecutorProtocol>
    
    public func execute(urlRequest: URLRequest, 
                        completionHandler: @escaping (Result<Data, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol {
        capturedExecuteURLRequest = urlRequest
        capturedExecuteCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedExecuteResult)
        }
        
        return stubbedExecuteTask
    }
    
    public func executeDownload(urlRequest: URLRequest,
                                customFilename: String?,
                                directory: Directory,
                                completionHandler: @escaping (Result<URL, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol {
        capturedExecuteDownloadURLRequest = urlRequest
        capturedExecuteDownloadCustomFilename = customFilename
        capturedExecuteDownloadDirectory = directory
        capturedExecuteDownloadCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedExecuteDownloadResult)
        }
        
        return stubbedExecuteDownloadTask
    }
}
