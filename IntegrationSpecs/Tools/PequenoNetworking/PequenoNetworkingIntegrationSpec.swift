import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!

            describe("using JSONSerialization") {
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                headers: nil)
                }
                
                describe("GET request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.get(endpoint: "/get",
                                        parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let jsonResponse = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(jsonResponse).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("DELETE request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(20)) { complete in
                            subject.delete(endpoint: "/delete",
                                           parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let jsonResponse = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(jsonResponse).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("POST request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.post(endpoint: "/post",
                                         body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let jsonResponse = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(jsonResponse).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PUT request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.put(endpoint: "/put",
                                        body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let jsonResponse = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(jsonResponse).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PATCH request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.patch(endpoint: "/patch",
                                          body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let jsonResponse = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(jsonResponse).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
            }
            
            describe("using Codable") {
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                headers: nil)
                }
                
                describe("GET request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.get(endpoint: "/get",
                                        parameters: nil) { (result: Result<HTTPBin, Error>) in
                                let responseURL = try? result.get().url
                                
                                expect(responseURL).to.equal("https://httpbin.org/get")
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("DELETE request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.delete(endpoint: "/delete",
                                           parameters: nil) { (result: Result<HTTPBin, Error>) in
                                let responseURL = try? result.get().url
                                
                                expect(responseURL).to.equal("https://httpbin.org/delete")
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("POST request") {
                    describe("without a body") {
                        it("completes with deserialized json") {
                            hangOn(for: .seconds(5)) { complete in
                                subject.post(endpoint: "/post",
                                             body: nil) { (result: Result<HTTPBin, Error>) in
                                    let responseURL = try? result.get().url
                                    
                                    expect(responseURL).to.equal("https://httpbin.org/post")
                                    
                                    complete()
                                }
                            }
                        }
                    }
                    
                    describe("with a body") {
                        it("completes with deserialized json") {
                            hangOn(for: .seconds(5)) { complete in
                                subject.post(endpoint: "/post",
                                             body: ["junk-drawer": ["sissors", "tape", "matches"],
                                                    "number-of-dogs": 2]) { (result: Result<HTTPBin, Error>) in
                                    let responseURL = try? result.get().url
                                    
                                    expect(responseURL).to.equal("https://httpbin.org/post")
                                    
                                    complete()
                                }
                            }
                        }
                    }
                }
                
                describe("PUT request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.put(endpoint: "/put",
                                        body: nil) { (result: Result<HTTPBin, Error>) in
                                let responseURL = try? result.get().url
                                
                                expect(responseURL).to.equal("https://httpbin.org/put")
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PATCH request") {
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.patch(endpoint: "/patch",
                                          body: nil) { (result: Result<HTTPBin, Error>) in
                                let responseURL = try? result.get().url
                                
                                expect(responseURL).to.equal("https://httpbin.org/patch")
                                
                                complete()
                            }
                        }
                    }
                }
            }
            
            describe("file transfers") {
                describe("downloading a file") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with url to downloaded image") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.downloadFile(endpoint: "/image/jpeg",
                                                 parameters: nil,
                                                 filename: "animal.jpeg",
                                                 directory: Directory(.caches(additionalPath: "session-downloadz/"))) { result in
                                if case let .success(url) = result {
                                    guard let imageData = try? Data(contentsOf: url) else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(imageData.count).to.beGreaterThan(0)
                                } else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                complete()
                            }
                        }
                    }
                }

                describe("uploading a file") {
                    var testBundle: Bundle!
                    var multipartFormData: Data!
                    
                    beforeEach {
                        testBundle = Bundle(for: self)
                        
                        let fileURL = testBundle.url(forResource: "file",
                                                     withExtension: "json")!
                        
                        let fileData = try! Data(contentsOf: fileURL)
                        
                        let boundaryUUID = UUID().uuidString
                        
                        multipartFormData = MultipartFormDataBuilder().buildMultipartFormData(data: fileData,
                                                                                              filename: "file.json",
                                                                                              boundaryUUID: boundaryUUID,
                                                                                              contentType: .octetStream)
                        
                        let multipartFormHeader = ["Content-Type": "multipart/form-data; boundary=Boundary-\(boundaryUUID)"]
                        
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: multipartFormHeader)
                    }
                    
                    describe("using JSONSerialization") {
                        it("completes with deserialized json") {
                            hangOn(for: .seconds(5)) { complete in
                                subject.uploadFile(endpoint: "/post",
                                                   parameters: nil,
                                                   data: multipartFormData) { result in
                                    if case .success(let jsonResponse) = result {
                                        guard let jsonResponse = jsonResponse as? [String: Any] else {
                                            failSpec()
                                            
                                            return
                                        }
                                        
                                        expect(jsonResponse).toNot.beEmpty()
                                    } else {
                                        failSpec()
                                    }
                                    
                                    complete()
                                }
                            }
                        }
                    }
                    
                    describe("using Codable") {
                        it("completes with deserialized json") {
                            hangOn(for: .seconds(5)) { complete in
                                subject.uploadFile(endpoint: "/post",
                                                   parameters: nil,
                                                   data: multipartFormData) { (result: Result<HTTPBin, Error>) in
                                    if case .success(let response) = result {
                                        expect(response.url).to.equal("https://httpbin.org/post")
                                        expect(response.files!.file).to.contain("Flipper")
                                    } else {
                                        failSpec()
                                    }
                                    
                                    complete()
                                }
                            }
                        }
                    }
                }
            }
            
            describe("using convenience init w/ UserDefaults") {
                beforeEach {
                    UserDefaults.standard.set("https://httpbin.org", forKey: PequenoNetworking.Constants.BaseURLKey)
                    
                    subject = PequenoNetworking()
                }
                
                afterEach {
                    UserDefaults.standard.removeObject(forKey: PequenoNetworking.Constants.BaseURLKey)
                }
                
                it("works") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.get(endpoint: "/get",
                                    parameters: nil) { result in
                            if case .success(let jsonResponse) = result {
                                guard let jsonResponse = jsonResponse as? [String: Any] else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                expect(jsonResponse).toNot.beEmpty()
                            } else {
                                failSpec()
                            }
                            
                            complete()
                        }
                    }
                }
            }
        }
    }
}
