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

open class FakeURLSessionTaskEngine: Fake, URLSessionTaskEngineProtocol {
    // MARK: - Captured properties
    
    public var capturedDataTaskURLRequest: URLRequest?
    public var capturedDataTaskCompletionHandler: ((Result<Data, Error>) -> Void)?
    
    public var capturedDownloadTaskURLRequest: URLRequest?
    public var capturedDownloadTaskCompletionHandler: ((Result<URL, Error>) -> Void)?
    
    public var capturedUploadTaskURLRequest: URLRequest?
    public var capturedUploadTaskData: Data?
    public var capturedUploadTaskCompletionHandler: ((Result<Data, Error>) -> Void)?
    
    // MARK: - Stubbed properties
    
    public var stubbedDataTask: URLSessionTaskProtocol = FakeURLSessionTask()
    public var stubbedDataTaskResult: Result<Data, Error> = .success("Lucky Day".data(using: .utf8)!)
    
    public var stubbedDownloadTask: URLSessionTaskProtocol = FakeURLSessionTask()
    public var stubbedDownloadTaskResult: Result<URL, Error> = {
        let url = URL(string: "https://dusty-bottoms.3amigos-99.party")!
        
        return .success(url)
    }()
    
    public var stubbedUploadTask: URLSessionTaskProtocol = FakeURLSessionTask()
    public var stubbedUploadTaskResult: Result<Data, Error> = .success("Ned Nederlander".data(using: .utf8)!)
    
    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public override init() { }
    
    // MARK: - <URLSessionExecutorProtocol>
    
    public func dataTask(urlRequest: URLRequest,
                         completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTaskProtocol {
        capturedDataTaskURLRequest = urlRequest
        capturedDataTaskCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedDataTaskResult)
        }
        
        return stubbedDataTask
    }
    
    public func downloadTask(urlRequest: URLRequest,
                             completionHandler: @escaping (Result<URL, Error>) -> Void) -> URLSessionTaskProtocol {
        capturedDownloadTaskURLRequest = urlRequest
        capturedDownloadTaskCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedDownloadTaskResult)
        }
        
        return stubbedDownloadTask
    }
    
    @discardableResult
    public func uploadTask(urlRequest: URLRequest,
                           data: Data,
                           completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTaskProtocol {
        capturedUploadTaskURLRequest = urlRequest
        capturedUploadTaskData = data
        capturedUploadTaskCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedUploadTaskResult)
        }
        
        return stubbedUploadTask
    }
}
