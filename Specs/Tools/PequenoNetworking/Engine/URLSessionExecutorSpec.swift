import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionExecutorSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionExecutor") {
            var subject: URLSessionExecutor!
            var fakeURLSession: FakeURLSession!
            var fakeFileManager: FakeFileManagerUtensils!
            var directory: Directory!
            
            var urlRequest: URLRequest!
            var lastExecutedURLSessionTask: URLSessionTaskProtocol!
            
            beforeEach {
                fakeURLSession = FakeURLSession()
                fakeFileManager = FakeFileManagerUtensils()
                directory = Directory(fileManager: fakeFileManager)
                
                subject = URLSessionExecutor(urlSession: fakeURLSession,
                                             fileManager: fakeFileManager)
                
                urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
            }
            
            describe("#execute(urlRequest:completionHandler:)") {
                var actualData: Data!
                var actualError: PequenoNetworking.Error!
                
                beforeEach {
                    lastExecutedURLSessionTask = subject.execute(urlRequest: urlRequest) { data, error in
                        actualData = data
                        actualError = error
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
                    
                    it("completes with dataTaskError") {
                        expect(actualData).to.beNil()
                        
                        expect(actualError).to.equal(.dataTaskError(wrappedError: FakeGenericError.whoCares))
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
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
                            
                            fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, response, nil)
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
                            
                            fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(data, response, nil)
                        }
                        
                        it("finally completes without error") {
                            expect(actualError).to.beNil()
                            expect(actualData).to.equal("doesn't-matter".data(using: .utf8))
                        }
                    }
                }
            }
            
            describe("#executeDownload(urlRequest:customFilename:directory:completionHandler:)") {
                var actualURL: URL!
                var actualError: PequenoNetworking.Error!
                
                beforeEach {
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    lastExecutedURLSessionTask = subject.executeDownload(urlRequest: urlRequest,
                                                                         customFilename: "hi.txt",
                                                                         directory: directory) { url, error in
                        actualURL = url
                        actualError = error
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
                    
                    it("completes with dataTaskError") {
                        expect(actualURL).to.beNil()
                        
                        expect(actualError).to.equal(.downloadTaskError(wrappedError: FakeGenericError.whoCares))
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, nil, nil)
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
                            
                            fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, response, nil)
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
                        }
                        
                        describe("when url session completes without a url") {
                            beforeEach {
                                fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, response, nil)
                            }
                            
                            it("completes with downloadError") {
                                expect(actualURL).to.beNil()
                                
                                expect(actualError).to.equal(.downloadError)
                            }
                        }
                        
                        describe("when url session completes with a url") {
                            var url: URL!
                            
                            beforeEach {
                                url = URL(string: "file:///tmp.data")
                            }
                            
                            describe("when the downloaded file CANNOT be migrated to user specified location") {
                                beforeEach {
                                    fakeFileManager.shouldThrowMigrateFileError = true
                                                                        
                                    fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(url, response, nil)
                                }
                                
                                it("completes with downloadFileManagerError") {
                                    expect(actualURL).to.beNil()
                                    expect(actualError).to.equal(.downloadFileManagerError(wrappedError: FakeGenericError.whoCares))
                                                                        
                                    expect(fakeFileManager.capturedMigrateFileSRCURL).to.equal(url)
                                    expect(fakeFileManager.capturedMigrateFileDSTURL).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))
                                }
                            }
                            
                            describe("when the downloaded file can be migrated to user specified location") {
                                beforeEach {
                                    fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(url, response, nil)
                                }
                                
                                it("finally completes without error") {
                                    expect(actualError).to.beNil()
                                    
                                    expect(actualURL).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))
                                    
                                    expect(fakeFileManager.capturedMigrateFileSRCURL).to.equal(url)
                                    expect(fakeFileManager.capturedMigrateFileDSTURL).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
