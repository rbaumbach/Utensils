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

public class FakeNetworkingEngine: NetworkingEngineProtocol {
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
    
    // MARK: - Init methods
    
    public init() { }
    
    // MARK: - <ClassicNetworkingEngineProtocol>
    
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
    }
}
