import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!
            
            var fakeURLSession: FakeURLSession!
            var fakeJSONSerializationWrapper: FakeJSONSerializationWrapper!
            var fakeJSONDecoder: FakeJSONDecoder!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            
            beforeEach {
                fakeURLSession = FakeURLSession()
                fakeJSONSerializationWrapper = FakeJSONSerializationWrapper()
                fakeJSONDecoder = FakeJSONDecoder()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                subject = PequenoNetworking(baseURL: "http://junkity-99.com",
                                            urlSession: fakeURLSession,
                                            jsonSerializationWrapper: fakeJSONSerializationWrapper,
                                            jsonDecoder: fakeJSONDecoder,
                                            dispatchQueueWrapper: fakeDispatchQueueWrapper)
            }
            
            it("has a baseURL") {
                expect(subject.baseURL).to.equal("http://junkity-99.com")
            }
            
            describe("request(endpoint:parameters:httpMethod:headers:completionHandler:)") {
                var actualResult: Result<Any, PequenoNetworking.Error>!
                
                describe("when url request cannot be constructed (when url is bad)") {
                    beforeEach {
                        subject.request(httpMethod: .get,
                                        endpoint: "_gannon!",
                                        headers: nil,
                                        parameters: nil) { result in
                            actualResult = result
                        }
                        
                        fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                    }
                    
                    it("completes with requestError") {
                        if case .failure(let error) = actualResult {
                            let expectedString = """
                            GET - http://junkity-99.com_gannon!
                            Parameters: N/A
                            Headers: N/A
                            """
                            
                            expect(error).to.equal(.requestError(expectedString))
                        } else {
                            failSpec()
                        }
                    }
                }
                
                describe("when url request can be constructed") {
                    beforeEach {
                        subject.request(httpMethod: .get,
                                        endpoint: "/link",
                                        headers: nil,
                                        parameters: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session completes with error") {
                        beforeEach {
                            fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with dataTaskError") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataTaskError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with malformed response") {
                        beforeEach {
                            fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with malformedResponseError") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.malformedResponseError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with valid response") {
                        var response: HTTPURLResponse!

                        describe("when url session completes with invalid status code") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 1,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                                
                                fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                                
                                fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                            }
                            
                            it("completes with invalidStatusCodeError") {
                                if case .failure(let error) = actualResult {
                                    expect(error).to.equal(.invalidStatusCodeError(statusCode: 1))
                                } else {
                                    failSpec()
                                }
                            }
                        }
                        
                        describe("when url session completes with nil data (but without error)") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 222,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                                
                                fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                                
                                fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                            }
                            
                            it("completes with dataError") {
                                if case .failure(let error) = actualResult {
                                    expect(error).to.equal(.dataError)
                                } else {
                                    failSpec()
                                }
                            }
                        }
                        
                        describe("when url session completes with valid status code and with data") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 222,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                            }
                            
                            describe("when the data CANNOT be deserialized") {
                                beforeEach {
                                    fakeJSONSerializationWrapper.shouldThrowJSONObjectException = true
                                    
                                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?("$".data(using: .utf8), response, nil)
                                    
                                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                                }
                                
                                it("completes with jsonObjectDecodeError") {
                                    if case .failure(let error) = actualResult {
                                        expect(error).to.equal(.jsonObjectDecodeError(wrappedError: FakeGenericError.whoCares))
                                    } else {
                                        failSpec()
                                    }
                                }
                            }
                            
                            describe("when the data can be deserialized") {
                                beforeEach {
                                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?("$".data(using: .utf8), response, nil)
                                    
                                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                                }
                                
                                it("finally completes with deserialized json... whew...") {
                                    if case .success(let success) = actualResult {
                                        let actualSuccess = success as! String
                                        
                                        expect(actualSuccess).to.equal("{ not-real: json }")
                                    } else {
                                        failSpec()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            describe("requestAndDeserialize(endpoint:parameters:httpMethod:headers:completionHandler:)") {
                var actualResult: Result<Dog, PequenoNetworking.Error>!
                
                describe("when url request cannot be constructed (when url is bad)") {
                    describe("when parameters are empty and headers are nil") {
                        beforeEach {
                            subject.requestAndDeserialize(httpMethod: .get,
                                                          endpoint: "_gannon!",
                                                          headers: nil,
                                                          parameters: nil) { result in
                                actualResult = result
                            }
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with requestError with proper text") {
                            if case .failure(let error) = actualResult {
                                let expectedString = """
                                GET - http://junkity-99.com_gannon!
                                Parameters: N/A
                                Headers: N/A
                                """
                                
                                expect(error).to.equal(.requestError(expectedString))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when parameters are NOT empty and headers are NOT nil and NOT empty") {
                        beforeEach {
                            subject.requestAndDeserialize(httpMethod: .get,
                                                          endpoint: "_gannon!",
                                                          headers: ["dog": "mutt"],
                                                          parameters: ["name": "maya"]) { result in
                                actualResult = result
                            }
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with requestError with proper text") {
                            if case .failure(let error) = actualResult {
                                let expectedString = """
                                GET - http://junkity-99.com_gannon!
                                Parameters: \(["name": "maya"])
                                Headers: \(["dog": "mutt"])
                                """
                                
                                expect(error).to.equal(.requestError(expectedString))
                            } else {
                                failSpec()
                            }
                        }
                    }
                }
                
                describe("when url request can be constructed") {
                    beforeEach {
                        subject.requestAndDeserialize(httpMethod: .get,
                                                      endpoint: "/link",
                                                      headers: nil,
                                                      parameters: nil) { result in
                            actualResult = result
                        }
                    }
                    
                    describe("when url session completes with error") {
                        beforeEach {
                            fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with dataTaskError") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.dataTaskError(wrappedError: FakeGenericError.whoCares))
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with malformed response") {
                        beforeEach {
                            fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                            
                            fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                        }
                        
                        it("completes with malformedResponseError") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.malformedResponseError)
                            } else {
                                failSpec()
                            }
                        }
                    }
                    
                    describe("when url session completes with valid response") {
                        var response: HTTPURLResponse!

                        describe("when url session completes with invalid status code") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 1,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                                
                                fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                                
                                fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                            }
                            
                            it("completes with invalidStatusCodeError") {
                                if case .failure(let error) = actualResult {
                                    expect(error).to.equal(.invalidStatusCodeError(statusCode: 1))
                                } else {
                                    failSpec()
                                }
                            }
                        }
                        
                        describe("when url session completes with nil data (but without error)") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 222,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                                
                                fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                                
                                fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                            }
                            
                            it("completes with dataError") {
                                if case .failure(let error) = actualResult {
                                    expect(error).to.equal(.dataError)
                                } else {
                                    failSpec()
                                }
                            }
                        }
                        
                        describe("when url session completes with valid status code and with data") {
                            beforeEach {
                                response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                           statusCode: 222,
                                                           httpVersion: String.empty,
                                                           headerFields: nil)
                            }
                            
                            describe("when the data CANNOT be deserialized") {
                                beforeEach {
                                    fakeJSONDecoder.shouldThrowDecodeException = true
                                    
                                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?("$".data(using: .utf8), response, nil)
                                    
                                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                                }
                                
                                it("completes with jsonObjectDecodeError") {
                                    if case .failure(let error) = actualResult {
                                        expect(error).to.equal(.jsonDecodeError(wrappedError: FakeGenericError.whoCares))
                                    } else {
                                        failSpec()
                                    }
                                }
                            }
                            
                            describe("when the data can be deserialized") {
                                beforeEach {
                                    fakeJSONDecoder.stubbedDecodedJSON = Dog()
                                    
                                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?("$".data(using: .utf8), response, nil)
                                    
                                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                                }
                                
                                it("finally completes with deserialized json... whew...") {
                                    if case .success(let success) = actualResult {
                                        expect(success).to.equal(Dog())
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
    }
}
