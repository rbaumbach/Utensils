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

public protocol MultipartFormDataBuilderProtocol {
    func buildMultipartFormData(fileLocationURL: URL,
                                boundaryUUID: String,
                                contentType: ContentType) -> Result<Data, Error>
    
    func buildMultipartFormData(fileLocationURL: URL,
                                boundaryUUID: String,
                                contentType: ContentType) throws -> Data
    
    func buildMultipartFormData(data: Data,
                                filename: String,
                                boundaryUUID: String,
                                contentType: ContentType) -> Data
}

public struct MultipartFormDataBuilder: MultipartFormDataBuilderProtocol {
    // MARK: - Private properties
    
    private let dataWrapper: DataWrapperProtocol
    
    // MARK: - Init methods
    
    public init(dataWrapper: DataWrapperProtocol = DataWrapper()) {
        self.dataWrapper = dataWrapper
    }
    
    public func buildMultipartFormData(fileLocationURL: URL,
                                       boundaryUUID: String,
                                       contentType: ContentType) -> Result<Data, Error> {
        do {
            let filename = fileLocationURL.lastPathComponent
            let fileData = try dataWrapper.loadData(contentsOfPath: fileLocationURL)
            
            let multipartFormData = buildMultipartFormData(data: fileData,
                                                           filename: filename,
                                                           boundaryUUID: boundaryUUID,
                                                           contentType: contentType)
            
            return .success(multipartFormData)
        } catch {
            return .failure(error)
        }
    }
    
    public func buildMultipartFormData(fileLocationURL: URL,
                                       boundaryUUID: String,
                                       contentType: ContentType) throws -> Data {
        let filename = fileLocationURL.lastPathComponent
        
        let fileData = try dataWrapper.loadData(contentsOfPath: fileLocationURL)
        
        return buildMultipartFormData(data: fileData,
                                      filename: filename,
                                      boundaryUUID: boundaryUUID,
                                      contentType: contentType)
    }
    
    public func buildMultipartFormData(data: Data,
                                       filename: String,
                                       boundaryUUID: String,
                                       contentType: ContentType) -> Data {
        let fullBoundaryString = "Boundary-\(boundaryUUID)"
        
        var multipartFormData = Data()
                
        multipartFormData.append("--\(fullBoundaryString)\r\n".data(using: .utf8)!)
        multipartFormData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        multipartFormData.append("Content-Type: \(contentType.rawValue)\r\n\r\n".data(using: .utf8)!)
        multipartFormData.append(data)
        multipartFormData.append("\r\n".data(using: .utf8)!)
        multipartFormData.append("--\(fullBoundaryString)--\r\n".data(using: .utf8)!)
        
        return multipartFormData
    }
}
