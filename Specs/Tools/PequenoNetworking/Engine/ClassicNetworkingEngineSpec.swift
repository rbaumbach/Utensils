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
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
                            fakeURLSessionExecutor.capturedExecuteCompletionHandler?(String.empty.data(using: .utf8), nil)
                            
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
        }
    }
}