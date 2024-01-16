import Quick
import Moocher
import Capsule
@testable import Utensils

final class NetworkingEngineSpec: QuickSpec {
    override class func spec() {
        describe("NetworkingEngine") {
            var subject: NetworkingEngine!
            
            var fakeURLRequestBuilder: FakeURLRequestBuilder!
            var fakeURLSessionExecutor: FakeURLSessionExecutor!
            var fakeJSONDecoder: FakeJSONDecoder!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            
            var fakeFileManager: FakeFileManagerUtensils!
            var directory: Directory!
            
            var actualResult: Result<String, PequenoNetworking.Error>!
            
            beforeEach {
                fakeURLRequestBuilder = FakeURLRequestBuilder()
                fakeURLSessionExecutor = FakeURLSessionExecutor()
                fakeJSONDecoder = FakeJSONDecoder()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                fakeFileManager = FakeFileManagerUtensils()
                directory = Directory(fileManager: fakeFileManager)
                
                subject = NetworkingEngine(urlRequestBuilder: fakeURLRequestBuilder,
                                           urlSessionExecutor: fakeURLSessionExecutor,
                                           jsonDecoder: fakeJSONDecoder,
                                           dispatchQueueWraper: fakeDispatchQueueWrapper)
            }
            
            describe("#get(baseURL:headers:endpoint:parameters:completionHandler:)") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.get(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    parameters: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        if case let .failure(error) = actualResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with nil data") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"

                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
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
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.delete(baseURL: String.empty,
                                       headers: nil,
                                       endpoint: String.empty,
                                       parameters: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        if case let .failure(error) = actualResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with nil data") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"

                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
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
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.post(baseURL: String.empty,
                                     headers: nil,
                                     endpoint: String.empty,
                                     body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        if case let .failure(error) = actualResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with nil data") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"

                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
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
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.put(baseURL: String.empty,
                                    headers: nil,
                                    endpoint: String.empty,
                                    body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        if case let .failure(error) = actualResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with nil data") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"

                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
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
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.patch(baseURL: String.empty,
                                      headers: nil,
                                      endpoint: String.empty,
                                      body: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with url request builder error") {
                        if case let .failure(error) = actualResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with nil data") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONDecoder.capturedDecodeTypeAsString).to.equal("String.Type")
                                expect(fakeJSONDecoder.capturedDecodeData).to.equal(String.empty.data(using: .utf8))
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }

                    describe("when the data can be deserialized") {
                        beforeEach {
                            fakeJSONDecoder.stubbedDecodedJSON = "String is Codable"

                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                                                        
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let decodedJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
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
            
            describe("#download(baseURL:headers:endpoint:parameters:filename:directory:completionHandler:)") {
                var actualDownloadResult: Result<URL, PequenoNetworking.Error>!
                
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
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
                        if case let .failure(error) = actualDownloadResult {
                            expect(error).to.equal(.dataError)
                        } else {
                            failSpec()
                        }
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when url session download executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteDownloadCompletionHandler?(nil, .dataError)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with url session executor error") {
                            if case .failure(let error) = actualDownloadResult {
                                expect(error).to.equal(.dataError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session download executor completes with nil url") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteDownloadCompletionHandler?(nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with data error") {
                            if case .failure(let error) = actualDownloadResult {
                                expect(error).to.equal(.downloadError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("whem url session download executor completes with url") {
                        var url: URL!
                        
                        beforeEach {
                            url = URL(string: "https://99-finally-dot-com.net")
                            
                            fakeURLSessionExecutor.capturedExecuteDownloadCompletionHandler?(url, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("finally completes with url result") {
                            if case .success(let actualURL) = actualDownloadResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteDownloadURLRequest).to.equal(expectedURLRequest)

                                expect(actualURL).to.equal(url)
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
