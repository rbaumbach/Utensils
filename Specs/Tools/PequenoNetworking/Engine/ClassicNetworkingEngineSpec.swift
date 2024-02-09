import Quick
import Moocher
import Capsule
@testable import Utensils

final class ClassicNetworkingEngineSpec: QuickSpec {
    override class func spec() {
        describe("ClassicNetworkingEngine") {
            var subject: ClassicNetworkingEngine!
            
            var fakeURLRequestBuilder: FakeURLRequestBuilder!
            var fakeURLSessionTaskEngine: FakeURLSessionTaskEngine!
            var fakeJSONSerializationWrapper: FakeJSONSerializationWrapper!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            
            var actualResult: Result<Any, Error>!
            
            beforeEach {
                fakeURLRequestBuilder = FakeURLRequestBuilder()
                fakeURLSessionTaskEngine = FakeURLSessionTaskEngine()
                fakeJSONSerializationWrapper = FakeJSONSerializationWrapper()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                subject = ClassicNetworkingEngine(urlRequestBuilder: fakeURLRequestBuilder,
                                                  urlSessionTaskEngine: fakeURLSessionTaskEngine,
                                                  jsonSerializationWrapper: fakeJSONSerializationWrapper,
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when data task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when data task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when data task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when data task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    describe("when data task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("when the data CANNOT be deserialized") {
                        beforeEach {
                            fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                            
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with json object decode error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                            
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                            expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                        }
                    }
                    
                    describe("when the data can be deserialized") {
                        beforeEach {
                            let result: Result<Data, Error> = .success(String.empty.data(using: .utf8)!)
                            
                            fakeURLSessionTaskEngine.capturedDataTaskCompletionHandler?(result)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with deserialized 'Any' result... finally") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedDataTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(String.empty.data(using: .utf8))
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
                        fakeURLRequestBuilder.stubbedResult = .failure(FakeGenericError.whoCares)
                        
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
                        let error = actualResult.getError() as! FakeGenericError
                        
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
                            actualResult = result
                        }
                    }
                    
                    describe("when upload task completes with error") {
                        beforeEach {
                            fakeURLSessionTaskEngine.capturedUploadTaskCompletionHandler?(.failure(FakeGenericError.whoCares))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with error") {
                            let error = actualResult.getError() as! FakeGenericError
                            
                            expect(error).to.equal(FakeGenericError.whoCares)
                        }
                    }
                    
                    describe("whem upload task completes with response") {
                        var data: Data!
                        
                        beforeEach {
                            data = "jason-voorhees".data(using: .utf8)!
                            
                            fakeURLSessionTaskEngine.capturedUploadTaskCompletionHandler?(.success(data))
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("finally completes with url result") {
                            if case .success(let anyJSON) = actualResult {
                                let expectedURLRequest = try! fakeURLRequestBuilder.stubbedResult.get()
                                
                                expect(fakeURLSessionTaskEngine.capturedUploadTaskURLRequest).to.equal(expectedURLRequest)
                                
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectData).to.equal(data)
                                expect(fakeJSONSerializationWrapper.capturedJSONObjectDataOptions).to.equal(.mutableContainers)
                                
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
