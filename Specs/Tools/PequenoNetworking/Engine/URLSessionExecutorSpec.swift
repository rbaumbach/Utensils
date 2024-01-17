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
            }
            
            describe("#execute(urlRequest:completionHandler:)") {
                var actualResult: Result<Data, PequenoNetworking.Error>!
                
                beforeEach {
                    subject = URLSessionExecutor(urlSession: fakeURLSession,
                                                 fileManager: fakeFileManager)
                    
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    lastExecutedURLSessionTask = subject.execute(urlRequest: urlRequest) { result in
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
                    
                    it("completes with dataTaskError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.dataTaskError(wrappedError: FakeGenericError.whoCares))
                        } else { failSpec() }
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDataTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with malformedResponseError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.malformedResponseError)
                        } else { failSpec() }
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
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.invalidStatusCodeError(statusCode: 1))
                            } else { failSpec() }
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
                            if case .success(let data) = actualResult {
                                expect(data).to.equal("doesn't-matter".data(using: .utf8))
                            } else { failSpec() }
                            
                            expect(fakeURLSession.capturedExtendedDataTaskURLRequest).to.equal(urlRequest)
                        }
                    }
                }
            }
            
            describe("#executeDownload(urlRequest:customFilename:directory:completionHandler:)") {
                var actualResult: Result<URL, PequenoNetworking.Error>!
                
                beforeEach {
                    subject = URLSessionExecutor(urlSession: fakeURLSession,
                                                 fileManager: fakeFileManager)
                                        
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    lastExecutedURLSessionTask = subject.executeDownload(urlRequest: urlRequest,
                                                                         customFilename: "hi.txt",
                                                                         directory: directory) { result in
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
                    
                    it("completes with dataTaskError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.downloadTaskError(wrappedError: FakeGenericError.whoCares))
                        } else { failSpec() }
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with malformedResponseError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.malformedResponseError)
                        } else { failSpec() }
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
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.invalidStatusCodeError(statusCode: 1))
                            } else { failSpec() }
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
                                if case .failure(let error) = actualResult {
                                    expect(error).to.equal(.downloadError)
                                } else { failSpec() }
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
                                    if case .failure(let error) = actualResult {
                                        expect(error).to.equal(.downloadFileManagerError(wrappedError: FakeGenericError.whoCares))
                                    } else { failSpec() }
                                                                        
                                    expect(fakeFileManager.capturedMigrateFileSRCURL).to.equal(url)
                                    expect(fakeFileManager.capturedMigrateFileDSTURL).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))
                                }
                            }
                            
                            describe("when the downloaded file can be migrated to user specified location") {
                                beforeEach {
                                    fakeURLSession.capturedExtendedDownloadTaskURLRequestCompletionHandler?(url, response, nil)
                                }
                                
                                it("finally completes without error") {
                                    if case .success(let url) = actualResult {
                                        expect(url).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))
                                    } else { failSpec() }
                                    
                                    expect(fakeURLSession.capturedExtendedDownloadTaskURLRequest).to.equal(urlRequest)
                                    
                                    expect(fakeFileManager.capturedMigrateFileSRCURL).to.equal(url)
                                    expect(fakeFileManager.capturedMigrateFileDSTURL).to.equal(URL(string: "file:///fake-documents-directory/hi.txt"))

                                }
                            }
                        }
                    }
                }
            }
            
            describe("#executeUpload(urlRequest:data:completionHandler:)") {
                var actualResult: Result<Data, PequenoNetworking.Error>!
                
                beforeEach {
                    subject = URLSessionExecutor(urlSession: fakeURLSession,
                                                 fileManager: fakeFileManager)
                    
                    urlRequest = URLRequest(url: URL(string: "http://junkity-99.com")!)
                    
                    let data = "cloud".data(using: .utf8)!
                    
                    lastExecutedURLSessionTask = subject.executeUpload(urlRequest: urlRequest,
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
                    
                    it("completes with uploadTaskError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.uploadTaskError(wrappedError: FakeGenericError.whoCares))
                        } else { failSpec() }
                    }
                }
                
                describe("when url session completes with malformed response") {
                    beforeEach {
                        fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(nil, nil, nil)
                    }
                    
                    it("completes with malformedResponseError") {
                        if case .failure(let error) = actualResult {
                            expect(error).to.equal(.malformedResponseError)
                        } else { failSpec() }
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
                        
                        it("completes with invalidStatusCodeError") {
                            if case .failure(let error) = actualResult {
                                expect(error).to.equal(.invalidStatusCodeError(statusCode: 1))
                            } else { failSpec() }
                        }
                    }
                    
                    describe("when url session completes with valid status code") {
                        beforeEach {
                            response = HTTPURLResponse(url: URL(string: "http://junkity-99.com")!,
                                                       statusCode: 200,
                                                       httpVersion: String.empty,
                                                       headerFields: nil)
                            
                            let data = "doesn't-matter".data(using: .utf8)
                            
                            fakeURLSession.capturedExtendedUploadTaskURLRequestCompletionHandler?(data, response, nil)
                        }
                        
                        it("finally completes without error") {
                            if case .success(let data) = actualResult {
                                expect(data).to.equal("doesn't-matter".data(using: .utf8))
                            } else { failSpec() }
                            
                            
                            expect(fakeURLSession.capturedExtendedUploadTaskURLRequest).to.equal(urlRequest)
                            expect(fakeURLSession.capturedExtendedUploadTaskURLRequestBodyData).to.equal("cloud".data(using: .utf8)!)
                        }
                    }
                }
            }
        }
    }
}
