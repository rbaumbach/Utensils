import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!
            
            var fakeClassicNetworkingEngine: FakeClassicNetworkingEngine!
            var fakeNetworkingEngine: FakeNetworkingEngine!
            
            var fakeFileManager: FakeFileManagerUtensils!
            var fakeUserDefaults: FakeUserDefaults!
            var directory: Directory!
            
            beforeEach {
                fakeClassicNetworkingEngine = FakeClassicNetworkingEngine()
                fakeNetworkingEngine = FakeNetworkingEngine()
                
                fakeUserDefaults = FakeUserDefaults()
                fakeUserDefaults.stubbedString = "https://ghost.busters"
                fakeUserDefaults.stubbedObject = ["city": "new-york"]
                
                fakeFileManager = FakeFileManagerUtensils()
                directory = Directory(fileManager: fakeFileManager)
            }
            
            it("has a convience init method that uses user defaults for baseURL and headers") {
                subject = PequenoNetworking(userDefaults: fakeUserDefaults)
                
                expect(subject.baseURL).to.equal("https://ghost.busters")
                expect(subject.headers).to.equal(["city": "new-york"])
            }
            
            it("has a baseURL") {
                subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                            headers: ["city": "new-york"],
                                            classicNetworkingEngine: fakeClassicNetworkingEngine,
                                            networkingEngine: fakeNetworkingEngine)
                
                expect(subject.baseURL).to.equal("https://ghost.busters")
            }
            
            it("has headers") {
                subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                            headers: ["city": "new-york"],
                                            classicNetworkingEngine: fakeClassicNetworkingEngine,
                                            networkingEngine: fakeNetworkingEngine)
                
                expect(subject.headers).to.equal(["city": "new-york"])
            }
            
            describe("JSONSerialization (ol' skoo)") {
                var stubbedResult: Result<Any, Error>!
                var actualResult: Result<Any, Error>!
                
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                headers: ["city": "new-york"],
                                                classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                networkingEngine: fakeNetworkingEngine)
                    
                    stubbedResult = .success("Back off man! I'm a scientist!")
                }
                
                describe("GET") {
                    beforeEach {
                        subject.get(endpoint: "/containment-unit",
                                    parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                                                
                        fakeClassicNetworkingEngine.capturedGetCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedGetBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedGetHeaders).to.equal(["city": "new-york"])
                        expect(fakeClassicNetworkingEngine.capturedGetParameters).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("DELETE") {
                    beforeEach {
                        subject.delete(endpoint: "/containment-unit",
                                       parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedDeleteCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedDeleteBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedDeleteHeaders).to.equal(["city": "new-york"])
                        expect(fakeClassicNetworkingEngine.capturedDeleteParameters).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("POST") {
                    beforeEach {
                        subject.post(endpoint: "/containment-unit",
                                     body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPostCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPostBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPostHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPostBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("PUT") {
                    beforeEach {
                        subject.put(endpoint: "/containment-unit",
                                    body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPutCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPutBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPutHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPutBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("PATCH") {
                    beforeEach {
                        subject.patch(endpoint: "/containment-unit",
                                      body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPatchCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPatchBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPatchHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPatchBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
            }
            
            describe("Codable networking") {
                var stubbedResult: Result<String, Error>!
                var actualResult: Result<String, Error>!
                
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                headers: ["city": "new-york"],
                                                classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                networkingEngine: fakeNetworkingEngine)
                    
                    stubbedResult = .success("Back off man! I'm a scientist!")
                }
                
                describe("GET") {
                    beforeEach {
                        subject.get<String>(endpoint: "/containment-unit",
                                            parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedGetCompletionHandler as? (Result<String, Error>) -> Void
                                                
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal("Back off man! I'm a scientist!")
                        
                        expect(fakeNetworkingEngine.capturedGetBaseURL).to.equal("https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedGetHeaders).to.equal(["city": "new-york"])
                        expect(fakeNetworkingEngine.capturedGetParameters).to.equal(["ghost": "slimer"])
                    }
                }
                
                describe("DELETE") {
                    beforeEach {
                        subject.delete<String>(endpoint: "/containment-unit",
                                               parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedDeleteCompletionHandler as? (Result<String, Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal("Back off man! I'm a scientist!")
                        
                        expect(fakeNetworkingEngine.capturedDeleteBaseURL).to.equal("https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedDeleteHeaders).to.equal(["city": "new-york"])
                        expect(fakeNetworkingEngine.capturedDeleteParameters).to.equal(["ghost": "slimer"])
                    }
                }
                
                describe("POST") {
                    beforeEach {
                        subject.post<String>(endpoint: "/containment-unit",
                                             body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPostCompletionHandler as? (Result<String, Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal("Back off man! I'm a scientist!")
                        
                        expect(fakeNetworkingEngine.capturedPostBaseURL).to.equal("https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedPostHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeNetworkingEngine.capturedPostBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                    }
                }
                
                describe("PUT") {
                    beforeEach {
                        subject.put<String>(endpoint: "/containment-unit",
                                            body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPutCompletionHandler as? (Result<String, Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal("Back off man! I'm a scientist!")
                        
                        expect(fakeNetworkingEngine.capturedPutBaseURL).to.equal("https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedPutHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeNetworkingEngine.capturedPutBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                    }
                }
                
                describe("PATCH") {
                    beforeEach {
                        subject.patch<String>(endpoint: "/containment-unit",
                                              body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPatchCompletionHandler as? (Result<String, Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal("Back off man! I'm a scientist!")
                        
                        expect(fakeNetworkingEngine.capturedPatchBaseURL).to.equal("https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedPatchHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeNetworkingEngine.capturedPatchBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                    }
                }
            }
            
            describe("file transfers ") {
                describe("downloading") {
                    var stubbedResult: Result<URL, Error>!
                    var actualResult: Result<URL, Error>!
                    
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                    headers: ["city": "new-york"],
                                                    classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                    networkingEngine: fakeNetworkingEngine)
                        
                        subject.downloadFile(endpoint: "/download",
                                             parameters: ["ghost": "scoleri-brothers"],
                                             filename: "scoleri-brothers",
                                             directory: directory) { result in
                            actualResult = result
                        }
                        
                        stubbedResult = fakeNetworkingEngine.stubbedDownloadFileResult
                        
                        fakeNetworkingEngine.capturedDownloadFileCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns proper result") {
                        let resultValue = try! actualResult.get()
                        
                        expect(resultValue).to.equal(URL(string: "https://99-stubby-99.party"))
                        
                        expect(fakeNetworkingEngine.capturedDownloadFileBaseURL).to.equal( "https://ghost.busters")
                        expect(fakeNetworkingEngine.capturedDownloadFileHeaders).to.equal(["city": "new-york"])
                        expect(fakeNetworkingEngine.capturedDownloadFileEndpoint).to.equal("/download")
                        expect(fakeNetworkingEngine.capturedDownloadFileParameters).to.equal(["ghost": "scoleri-brothers"])
                        expect(fakeNetworkingEngine.capturedDownloadFileFilename).to.equal("scoleri-brothers")
                        
                        let actualDirectoryURL = try! fakeNetworkingEngine.capturedDownloadFileDirectory!.url()
                        let actualDirectoryURLString = actualDirectoryURL.absoluteString
                        
                        expect(actualDirectoryURLString).to.equal("file:///fake-documents-directory/")
                    }
                }
                
                describe("uploading") {
                    var data: Data!
                    
                    beforeEach {
                        data = "glad I don't have to do multipart form stuff here".data(using: .utf8)!
                    }
                    
                    describe("JSONSerialization (ol' skoo)") {
                        var stubbedResult: Result<Any, Error>!
                        var actualResult: Result<Any, Error>!
                        
                        beforeEach {
                            subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                        headers: ["city": "new-york"],
                                                        classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                        networkingEngine: fakeNetworkingEngine)
                            
                            subject.uploadFile(endpoint: "/upload",
                                               parameters: ["ghost": "scoleri-brothers"],
                                               data: data) { result in
                                actualResult = result
                            }
                            
                            stubbedResult = fakeClassicNetworkingEngine.stubbedUploadFileResult
                            
                            fakeClassicNetworkingEngine.capturedUploadFileCompletionHandler?(stubbedResult)
                        }
                        
                        it("returns proper result") {
                            let typedResult = try! actualResult.get() as! String
                            
                            expect(typedResult).to.equal("Éxito")
                            
                            expect(fakeClassicNetworkingEngine.capturedUploadFileBaseURL).to.equal("https://ghost.busters")
                            expect(fakeClassicNetworkingEngine.capturedUploadFileHeaders).to.equal(["city": "new-york"])
                            expect(fakeClassicNetworkingEngine.capturedUploadFileEndpoint).to.equal("/upload")
                            expect(fakeClassicNetworkingEngine.capturedUploadFileParameters).to.equal(["ghost": "scoleri-brothers"])
                            expect(fakeClassicNetworkingEngine.capturedUploadFileData).to.equal(data)
                        }
                    }
                    
                    describe("Codable") {
                        var stubbedResult: Result<String, Error>!
                        var actualResult: Result<String, Error>!
                        
                        beforeEach {
                            subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                        headers: ["city": "new-york"],
                                                        classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                        networkingEngine: fakeNetworkingEngine)
                            
                            subject.uploadFile(endpoint: "/upload",
                                               parameters: ["ghost": "scoleri-brothers"],
                                               data: data) { result in
                                actualResult = result
                            }
                            
                            stubbedResult = .success("Back off man! I'm a scientist!")

                            let typedCompletionHandler = fakeNetworkingEngine.capturedUploadFileCompletionHandler as? (Result<String, Error>) -> Void
                            
                            typedCompletionHandler?(stubbedResult)
                        }
                        
                        it("returns proper result") {
                            let resultValue = try! actualResult.get()
                            
                            expect(resultValue).to.equal("Back off man! I'm a scientist!")
                            
                            expect(fakeNetworkingEngine.capturedUploadFileBaseURL).to.equal("https://ghost.busters")
                            expect(fakeNetworkingEngine.capturedUploadFileHeaders).to.equal(["city": "new-york"])
                            expect(fakeNetworkingEngine.capturedUploadFileEndpoint).to.equal("/upload")
                            expect(fakeNetworkingEngine.capturedUploadFileParameters).to.equal(["ghost": "scoleri-brothers"])
                            expect(fakeNetworkingEngine.capturedUploadFileData).to.equal(data)
                        }
                    }
                }
            }
        }
    }
}
