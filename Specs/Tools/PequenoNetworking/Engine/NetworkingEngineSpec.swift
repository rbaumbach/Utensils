import Quick
import Moocher
import Capsule
@testable import Utensils

final class NetworkingEngineSpec: QuickSpec {
    override class func spec() {
        describe("NetworkingEngine") {
            var subject: NetworkingEngine!
            
            var fakeURLRequestBuilder: FakeURLRequestBuilder!
            var fakeURLSessionTaskEngine: FakeURLSessionTaskEngine!
            var fakeJSONDecoder: FakeJSONDecoder!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            
            var fakeFileManager: FakeFileManagerUtensils!
            var directory: Directory!
            
            var actualResult: Result<String, Error>!
            
            beforeEach {
                fakeURLRequestBuilder = FakeURLRequestBuilder()
                fakeURLSessionTaskEngine = FakeURLSessionTaskEngine()
                fakeJSONDecoder = FakeJSONDecoder()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                fakeFileManager = FakeFileManagerUtensils()
                directory = Directory(fileManager: fakeFileManager)
                
                subject = NetworkingEngine(urlRequestBuilder: fakeURLRequestBuilder,
                                           urlSessionTaskEngine: fakeURLSessionTaskEngine,
                                           jsonDecoder: fakeJSONDecoder,
                                           dispatchQueueWraper: fakeDispatchQueueWrapper)
            }
            
            describe("#get(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.get(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    parameters: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualResult.getError() as? FakeGenericError
                        
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.get(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    parameters: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualResult.getError() as? FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as? FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                            expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)

                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))

                                expect(decodedJSON).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#delete(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.delete(baseURL: String.empty,
                                       headers: nil,
                                       endpoint: String.empty,
                                       parameters: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualResult.getError() as? FakeGenericError
                        
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.delete(baseURL: String.empty,
                                       headers: nil,
                                       endpoint: String.empty,
                                       parameters: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualResult.getError() as? FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as? FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                            expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)

                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))

                                expect(decodedJSON).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#post(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.post(baseURL: String.empty,
                                     headers: nil,
                                     endpoint: String.empty,
                                     body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualResult.getError() as? FakeGenericError
                                                
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.post(baseURL: String.empty,
                                     headers: nil,
                                     endpoint: String.empty,
                                     body: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                            expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)

                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))

                                expect(decodedJSON).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#put(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.put(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualResult.getError() as? FakeGenericError
                                                
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.put(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    body: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                                                
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                            expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)

                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))

                                expect(decodedJSON).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#patch(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.patch(baseURL: String.empty,
                                      headers: nil,
                                      endpoint: String.empty,
                                      body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualResult.getError() as? FakeGenericError
                                                
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.patch(baseURL: String.empty,
                                      headers: nil,
                                      endpoint: String.empty,
                                      body: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                            expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)

                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))

                                expect(decodedJSON).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#downloadFile(baseURL:headers:endpoint:parameters:filename:directory:completionHandler:)") {
                var actualDownloadResult: Result<URL, Error>!
                
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.downloadFile(baseURL: String.empty,
                                             headers: nil,
                                             endpoint: String.empty,
                                             parameters: nil,
                                             filename: "hi.txt",
                                             directory: directory) { result in
                            actualDownloadResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualDownloadResult.getError() as? FakeGenericError
                                                
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.downloadFile(baseURL: String.empty,
                                             headers: nil,
                                             endpoint: String.empty,
                                             parameters: nil,
                                             filename: "hi.txt",
                                             directory: directory) { result in
                            actualDownloadResult = result
                        }
                    }
                    
                    describe("when url session download executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDownloadTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualDownloadResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("whem url session download executor completes with url") {
                        var url: URL!
                        
                        beforeEach {
                            url = URL(string: "https://99-finally-dot-com.net")!
                                                        
                            fakeURLSessionTaskEngine.capturedDownloadTaskCompletionHandler?(.success(url))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("finally completes with url result") {
                            if case .success(let actualURL) = actualDownloadResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDownloadTaskURLRequest).to.equal(expectedURLRequest)

                                expect(actualURL).to.equal(url)
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#uploadFile(baseURL:headers:endpoint:parameters:data:completionHandler:)") {
                var actualUploadResult: Result<String, Error>!
                
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
                        subject.uploadFile(baseURL: String.empty,
                                           headers: nil,
                                           endpoint: String.empty,
                                           parameters: nil,
                                           data: "data".data(using: .utf8)!) { result in
                            actualUploadResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        let error = actualUploadResult.getError() as? FakeGenericError
                                                
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url request can be built") {
                    beforeEach {
                        subject.uploadFile(baseURL: String.empty,
                                           headers: nil,
                                           endpoint: String.empty,
                                           parameters: nil,
                                           data: "data".data(using: .utf8)!) { result in
                            actualUploadResult = result
                        }
                    }
                    
                    describe("when url session download executor completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedUploadTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            let error = actualUploadResult.getError() as? FakeGenericError
                                                    
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("whem url session download executor completes with response") {
                        var data: Data!
                        
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"
                            
                            data = "jason-voorhees".data(using: .utf8)!
                            
                            fakeURLSessionTaskEngine.capturedUploadTaskCompletionHandler?(.success(data))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("finally completes with url result") {
                            if case .success(let actualResponse) = actualUploadResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedUploadTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(data)

                                expect(actualResponse).to.equal("String is Codable")
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
        }
    }
}
