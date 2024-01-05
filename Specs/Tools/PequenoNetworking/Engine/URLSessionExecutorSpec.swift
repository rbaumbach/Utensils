import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionExecutorSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionExecutor") {
            var subject: URLSessionExecutor!
            var fakeURLSession: FakeURLSession!
            
            beforeEach {
                fakeURLSession = FakeURLSession()
                
                subject = URLSessionExecutor(urlSession: fakeURLSession)
            }
            
            describe("#execute(urlRequest:completionHandler:)") {
                var actualData: Data!
                var actualError: PequenoNetworking.Error!
                
                beforeEach {
                    let urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    subject.execute(urlRequest: urlRequest) { data, error in
                        actualData = data
                        actualError = error
                    }
                }
                
                it("hangs onto the executed data task and 'resumed'") {
                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                    
                    expect(fakeURLSession.stubbedDataTaskWithURLRequest.didCallResume).to.beTruthy()
                    
                    expect(subject.lastExecutedDataTask).to.beKindOf(FakeURLSessionDataTask.self)
                }
                
                describe("when url session completes with error") {
                    beforeEach {
                        fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                    }
                    
                    it("completes with dataTaskError") {
                        expect(actualData).to.beNil()
                        
                        expect(actualError).to.equal(.dataTaskError(wrappedError: FakeGenericError.whoCares))
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with malformedResponseError") {
                        expect(actualError).to.equal(.malformedResponseError)
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
                        }
                        
                        it("completes with invalidStatusCodeError") {
                            expect(actualError).to.equal(.invalidStatusCodeError(statusCode: 1))
                        }
                    }
                    
                    describe("when url session completes with valid status code") {
                        beforeEach {
                            response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                       statusCode: 200,
                                                       httpVersion: String.empty,
                                                       headerFields: nil)
                            
                            let data = "doesn't-matter".data(using: .utf8)
                            
                            fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(data, response, nil)
                        }
                        
                        it("finally completes without error") {
                            expect(actualError).to.beNil()
                            expect(actualData).to.equal("doesn't-matter".data(using: .utf8))
                        }
                    }
                }
            }
        }
    }
}
