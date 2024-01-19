import Quick
import Moocher
import Capsule
@testable import Utensils

final class ClassicNetworkingEngineSpec: QuickSpec {
    override class func spec() {
        describe("ClassicNetworkingEngine") {
            var subject: ClassicNetworkingEngine!
            
            var fakeURLRequestBuilder: FakeURLRequestBuilder!
            var fakeURLSessionExecutor: FakeURLSessionExecutor!
            var fakeJSONSerializationWrapper: FakeJSONSerializationWrapper!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            
            var actualResult: Result<Any, PequenoNetworking.Error>!
            
            beforeEach {
                fakeURLRequestBuilder = FakeURLRequestBuilder()
                fakeURLSessionExecutor = FakeURLSessionExecutor()
                fakeJSONSerializationWrapper = FakeJSONSerializationWrapper()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                subject = ClassicNetworkingEngine(urlRequestBuilder: fakeURLRequestBuilder,
                                                  urlSessionExecutor: fakeURLSessionExecutor,
                                                  jsonSerializationWrapper: fakeJSONSerializationWrapper,
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            if case .failure(let error) = actualResult {
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, PequenoNetworking.Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
            }
            
            describe("#uploadFile(baseURL:headers:endpoint:parameters:data:completionHandler:") {
                describe("when url request cannot be built") {
                    beforeEach {
                        fakeURLRequestBuilder.stubbedResult = .failure(.dataError)
                        
                        subject.uploadFile(baseURL: String.empty,
                                           headers: nil,
                                           endpoint: String.empty,
                                           parameters: nil,
                                           data: "data".data(using: .utf8)!) { result in
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
                        subject.uploadFile(baseURL: String.empty,
                                           headers: nil,
                                           endpoint: String.empty,
                                           parameters: nil,
                                           data: "data".data(using: .utf8)!) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session download executor completes with error") {
                        beforeEach {
                            fakeURLSessionExecutor.capturedExecuteUploadCompletionHandler?(.failure(.dataError))
                            
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
                    
                    describe("whem url session download executor completes with response") {
                        var data: Data!
                        
                        beforeEach {
                            data = "jason-voorhees".data(using: .utf8)!
                            
                            fakeURLSessionExecutor.capturedExecuteUploadCompletionHandler?(.success(data))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("finally completes with url result") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionExecutor.capturedExecuteUploadURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(data)
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectOptions).to.equal(.mutableContainers)
                                
                                let expectedResult = fakeJSONSerializationWrapper.stubbedJSONObject as! String
                                
                                let actualSuccessfulResult = anyJSON as! String
                                
                                expect(actualSuccessfulResult).to.equal(expectedResult)
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
