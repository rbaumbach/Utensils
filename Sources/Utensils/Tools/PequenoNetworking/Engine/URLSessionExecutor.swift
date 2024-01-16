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

// TODO: Update to use Result
// TODO: Add Bool to let user decide if we should .resume() right away
// TODO: Rename this class to something like URLSessionBuilder

public protocol URLSessionExecutorProtocol {
    @discardableResult
    func execute(urlRequest: URLRequest,
                 completionHandler: @escaping (Result<Data, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol
    
    @discardableResult
    func executeDownload(urlRequest: URLRequest,
                         customFilename: String?,
                         directory: Directory,
                         completionHandler: @escaping (Result<URL, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol
}

open class URLSessionExecutor: URLSessionExecutorProtocol {
    // MARK: - Private properties
        
    private let urlSession: URLSessionProtocol
    private let fileManager: FileManagerUtensilsProtocol
    
    // MARK: - Readonly properties
    
    public private(set) var lastExecutedURLSessionTask: URLSessionTaskProtocol?
    
    // MARK: - Init methods
    
    public init(urlSession: URLSessionProtocol = URLSession.shared,
                fileManager: FileManagerUtensilsProtocol = FileManager.default) {
        self.urlSession = urlSession
        self.fileManager = fileManager
    }
    
    // MARK: - Public methods
    
    @discardableResult
    public func execute(urlRequest: URLRequest,
                        completionHandler: @escaping (Result<Data, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol {
        let dataTask = urlSession.dataTask(urlRequest: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(.dataTaskError(wrappedError: error)))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.malformedResponseError))
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.invalidStatusCodeError(statusCode: response.statusCode)))
                
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataError))
                
                return
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
        
        lastExecutedURLSessionTask = dataTask
        
        return dataTask
    }

    @discardableResult
    public func executeDownload(urlRequest: URLRequest,
                                customFilename: String?,
                                directory: Directory,
                                completionHandler: @escaping (Result<URL, PequenoNetworking.Error>) -> Void) -> URLSessionTaskProtocol {
        let downloadTask = urlSession.downloadTask(urlRequest: urlRequest) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completionHandler(.failure(.downloadTaskError(wrappedError: error)))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.malformedResponseError))
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.invalidStatusCodeError(statusCode: response.statusCode)))
                
                return
            }
            
            guard let tempURL = tempURL else {
                completionHandler(.failure(.downloadError))
                
                return
            }
            
            do {
                let migratedFileURL = try self.migrateFile(customFilename: customFilename,
                                                           directory: directory,
                                                           tempURL: tempURL)
                
                completionHandler(.success(migratedFileURL))
            } catch {
                completionHandler(.failure(.downloadFileManagerError(wrappedError: error)))
            }
        }
        
        downloadTask.resume()
        
        lastExecutedURLSessionTask = downloadTask
        
        return downloadTask
    }
    
    // MARK: - Private methods
        
    private func migrateFile(customFilename: String?,
                             directory: DirectoryProtocol,
                             tempURL: URL) throws -> URL {
        let downloadedTempFileName = tempURL.lastPathComponent
        let filemame = customFilename ?? downloadedTempFileName
                
        let fullMigrationFileLocationAndName = try directory.url().appendingPathComponent(filemame)
        
        try fileManager.migrateFile(at: tempURL, 
                                    to: fullMigrationFileLocationAndName)
        
        return fullMigrationFileLocationAndName
    }
}
