import Quick
import Moocher
import Capsule
@testable import Utensils

// TODO: Fix tests for the invalidStatusCode update

final class URLSessionTaskEngineSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionTaskEngine") {
            var subject: URLSessionTaskEngine!
            var fakeURLSession: FakeURLSession!
            
            var urlRequest: URLRequest!
            var lastExecutedURLSessionTask: URLSessionTaskProtocol!
            
            beforeEach {
                fakeURLSession = FakeURLSession()
            }
            
            describe("#dataTask(urlRequest:completionHandler:)") {
                var actualResult: Result<Data, Error>!
                
                beforeEach {
                    subject = URLSessionTaskEngine(urlSession: fakeURLSession)
                    
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    lastExecutedURLSessionTask = subject.dataTask(urlRequest: urlRequest) { result in
                        actualResult = result
                    }
                }
                
                it("hangs onto the executed data task and is 'resumed' and returned") {
                    fakeURLSession.capturedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                    
                    expect(fakeURLSession.stubbedExtendedDataTaskForURLRequest.didCallResume).to.beTruthy()
                    expect(subject.lastExecutedURLSessionTask as? FakeURLSessionTask).to.equal(lastExecutedURLSessionTask as? FakeURLSessionTask)
                }
                
                describe("when url session completes with error") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                    }
                    
                    it("completes with url session error") {
                        let error = actualResult.getError() as? FakeGenericError
                        
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with invalidSessionResponse") {
                        let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                        
                        expect(error).to.equal(.invalidSessionResponse)
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
                            
                            fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                        }
                        
                        it("completes with invalidStatusCode") {
                            let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                            
                            expect(error).toNot.beNil()
//                            expect(error).to.equal(.invalidStatusCode(statusCode: 1))
                        }
                    }
                    
                    describe("when url session completes with valid status code") {
                        beforeEach {
                            response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                       statusCode: 200,
                                                       httpVersion: String.empty,
                                                       headerFields: nil)
                        }
                        
                        describe("when url session completes without response data") {
                            beforeEach {
                                fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, response, nil)
                            }
                            
                            it("completes with invalidSessionItem") {
                                let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                                
                                expect(error).to.equal(.invalidSessionItem(type: Data.self))
                            }
                        }
                        
                        describe("when url session completes with response data") {
                            var data: Data!
                            
                            beforeEach {
                                data = "doesn't-matter".data(using: .utf8)
                                
                                fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(data, response, nil)
                            }
                            
                            it("finally completes without error") {
                                let data = try? actualResult.get()
                                
                                expect(data).to.equal("doesn't-matter".data(using: .utf8))
                                
                                expect(fakeURLSession.capturedExtendedDataTaskURLRequest).to.equal(urlRequest)
                            }
                        }
                    }
                }
            }
            
            describe("#downloadTask(urlRequest:completionHandler:)") {
                var actualResult: Result<URL, Error>!
                
                beforeEach {
                    subject = URLSessionTaskEngine(urlSession: fakeURLSession)
                    
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    lastExecutedURLSessionTask = subject.downloadTask(urlRequest: urlRequest) { result in
                        actualResult = result
                    }
                }
                
                it("hangs onto the executed download task and is 'resumed' and returned") {
                    fakeURLSession.capturedDownloadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    
                    expect(fakeURLSession.stubbedExtendedDownloadTaskForURLRequest.didCallResume).to.beTruthy()
                    expect(subject.lastExecutedURLSessionTask as? FakeURLSessionTask).to.equal(lastExecutedURLSessionTask as? FakeURLSessionTask)
                }
                
                describe("when url session completes with error") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                    }
                    
                    it("completes with url session error") {
                        let error = actualResult.getError() as? FakeGenericError
                        
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with invalidSessionResponse") {
                        let error = actualResult.getError() as? URLSessionTaskEngine.Error<URL>
                        
                        expect(error).to.equal(.invalidSessionResponse)
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
                            
                            fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, response, nil)
                        }
                        
                        it("completes with invalidStatusCode") {
                            let error = actualResult.getError() as? URLSessionTaskEngine.Error<URL>
                            
                            expect(error).toNot.beNil()
//                            expect(error).to.equal(.invalidStatusCode(statusCode: 1))
                        }
                    }
                    
                    describe("when url session completes with valid status code") {
                        beforeEach {
                            response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                       statusCode: 200,
                                                       httpVersion: String.empty,
                                                       headerFields: nil)
                        }
                        
                        describe("when url session completes without a url") {
                            beforeEach {
                                fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, response, nil)
                            }
                            
                            it("completes with invalidSessionItem") {
                                let error = actualResult.getError() as? URLSessionTaskEngine.Error<URL>
                                
                                expect(error).to.equal(.invalidSessionItem(type: URL.self))
                            }
                        }
                        
                        describe("when url session completes with a url") {
                            var url: URL!
                            
                            beforeEach {
                                url = URL(string: "file:///tmp.data")
                                
                                fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(url, response, nil)
                            }
                            
                            it("finally completes without error") {
                                let actualURL = try? actualResult.get()
                                
                                expect(actualURL).to.equal(url)
                                
                                expect(fakeURLSession.capturedExtendedDownloadTaskURLRequest).to.equal(urlRequest)
                            }
                        }
                    }
                }
            }
            
            describe("#uploadTask(urlRequest:data:completionHandler:)") {
                var actualResult: Result<Data, Error>!
                
                beforeEach {
                    subject = URLSessionTaskEngine(urlSession: fakeURLSession)
                    
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    let data = "cloud".data(using: .utf8)!
                    
                    lastExecutedURLSessionTask = subject.uploadTask(urlRequest: urlRequest,
                                                                    data: data) { result in
                        actualResult = result
                    }
                }
                
                it("hangs onto the executed upload task and is 'resumed' and returned") {
                    fakeURLSession.capturedUploadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    
                    expect(fakeURLSession.stubbedExtendedUploadTaskForURLRequest.didCallResume).to.beTruthy()
                    expect(subject.lastExecutedURLSessionTask as? FakeURLSessionTask).to.equal(lastExecutedURLSessionTask as? FakeURLSessionTask)
                }
                
                describe("when url session completes with error") {
                    beforeEach {
                        fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(nil, nil, FakeGenericError.whoCares)
                    }
                    
                    it("completes with url session error") {
                        let error = actualResult.getError() as? FakeGenericError
                        
                        expect(error).to.equal(FakeGenericError.whoCares)
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with invalidSessionResponse") {
                        let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                        
                        expect(error).to.equal(.invalidSessionResponse)
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
                            
                            fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(nil, response, nil)
                        }
                        
                        it("completes with invalidStatusCode") {
                            let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                            
                            expect(error).toNot.beNil()
//                            expect(error).to.equal(.invalidStatusCode(statusCode: 1))
                        }
                    }
                    
                    describe("when url session completes with valid status code") {
                        beforeEach {
                            response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                       statusCode: 200,
                                                       httpVersion: String.empty,
                                                       headerFields: nil)
                        }
                        
                        describe("when url session completes without response data") {
                            beforeEach {
                                fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(nil, response, nil)
                            }
                            
                            it("completes with invalidSessionItem") {
                                let error = actualResult.getError() as? URLSessionTaskEngine.Error<Data>
                                
                                expect(error).to.equal(.invalidSessionItem(type: Data.self))
                            }
                        }
                        
                        describe("when url session completes with response data") {
                            var data: Data!
                            
                            beforeEach {
                                data = "doesn't-matter".data(using: .utf8)
                                
                                fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(data, response, nil)
                            }
                            
                            it("finally completes without error") {
                                let actualData = try? actualResult.get()
                                
                                expect(actualData).to.equal(data)
                                
                                expect(fakeURLSession.capturedExtendedUploadTaskURLRequest).to.equal(urlRequest)
                            }
                        }
                    }
                }
            }
            
            describe("when shouldExecuteTasksImmediately is set to false") {
                beforeEach {
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    subject = URLSessionTaskEngine(shouldExecuteTasksImmediately: false,
                                                   urlSession: fakeURLSession)
                }
                
                it("doesn't automatically resume() the tasks") {
                    let dataTask = subject.dataTask(urlRequest: urlRequest, completionHandler: { _ in })
                    
                    let downloadTask = subject.downloadTask(urlRequest: urlRequest,
                                                            completionHandler: { _ in })
                    
                    let uploadTask = subject.uploadTask(urlRequest: urlRequest,
                                                        data: "upload".data(using: .utf8)!,
                                                        completionHandler: { _ in })
                    
                    expect((dataTask as? FakeURLSessionTask)?.didCallResume).to.beFalsy()
                    expect((downloadTask as? FakeURLSessionTask)?.didCallResume).to.beFalsy()
                    expect((uploadTask as? FakeURLSessionTask)?.didCallResume).to.beFalsy()
                }
            }
        }
    }
}
