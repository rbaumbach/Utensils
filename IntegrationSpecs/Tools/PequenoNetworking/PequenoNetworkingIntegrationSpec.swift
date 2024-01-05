import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!
            
            describe("using JSONSerialization") {
                describe("GET request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.get(endpoint: "/get",
                                        parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(quotes).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("DELETE request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(20)) { complete in
                            subject.delete(endpoint: "/delete",
                                           parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(quotes).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("POST request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.post(endpoint: "/post",
                                         body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(quotes).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PUT request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.put(endpoint: "/put",
                                        body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(quotes).toNot.beEmpty()
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PATCH request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.patch(endpoint: "/patch",
                                          body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
                                        failSpec()
                                        
                                        return
                                    }
                                    
                                    expect(quotes).toNot.beEmpty()
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
                describe("GET request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.get(endpoint: "/get",
                                        parameters: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/get")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("DELETE request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.delete(endpoint: "/delete",
                                           parameters: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/delete")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("POST request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.post(endpoint: "/post",
                                         body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/post")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PUT request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.put(endpoint: "/put",
                                        body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/put")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PATCH request") {
                    beforeEach {
                        subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                                    headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.patch(endpoint: "/patch",
                                          body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/patch")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
            }
            
            describe("using convenience init w/ UserDefaults") {
                beforeEach {
                    UserDefaults.standard.set("https://httpbin.org", forKey: PequenoNetworkingConstants.BaseURLKey)
                    
                    subject = PequenoNetworking()
                }
                
                afterEach {
                    UserDefaults.standard.removeObject(forKey: PequenoNetworkingConstants.BaseURLKey)
                }
                
                it("works") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.get(endpoint: "/get",
                                    parameters: nil) { result in
                            if case .success(let jsonResponse) = result {
                                guard let quotes = jsonResponse as? [String: Any] else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                expect(quotes).toNot.beEmpty()
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
